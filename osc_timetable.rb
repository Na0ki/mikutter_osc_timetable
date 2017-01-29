# -*- coding: utf-8 -*-
require 'httpclient'
require 'nokogiri'
require 'pp'
require 'rss'

require_relative 'model'

Plugin.create(:osc_timetable) do
  command(:osc,
          name: 'OSC',
          condition: lambda { |_| true },
          visible: true,
          icon: get_skin('osc.gif'),
          role: :window) do |_|
    tab(:osc, 'OSC') do
      temporary_tab
      set_deletable true
      timeline :osc_list
      active!
    end
    Thread.new{
      open("http://kokuda.org/service/rss/osclink/").read
    }.next{|doc|
      RSS::Parser.parse(doc)
    }.next{|rss|
      rss.items.each do |item|
        Plugin::OSCTimetable::OpenSourceConference[item.link].next { |osc|
          timeline(:osc_list) << osc
        }.trap{|err|
          error err
        }
      end
    }.trap{|err|
      error err
    }
  end

  intent Plugin::OSCTimetable::OpenSourceConference, label: 'OSC' do |intent_token|
    osc = intent_token.model
    tab_slug = :"osc_#{osc.idname}"
    if Plugin::GUI::Tab.exist?(tab_slug)
      Plugin::GUI::Tab.instance(tab_slug).active!
    else
      tab(tab_slug, osc.name) do
        temporary_tab
        set_deletable true
        set_icon osc.user.icon
        timeline(:"osc_#{osc.idname}_timetables")
        active!
      end
      osc.timetables.next { |tts|
        timeline(:"osc_#{osc.idname}_timetables") << tts
      }.trap { |err| error err }
    end
  end

  intent Plugin::OSCTimetable::Timetable, label: 'OSCタイムテーブル' do |intent_token|
    timetable = intent_token.model
    tab_slug = :"osc_lectures_#{timetable.uri}"
    if Plugin::GUI::Tab.exist?(tab_slug)
      Plugin::GUI::Tab.instance(tab_slug).active!
    else
      tab(tab_slug, timetable.title) do
        temporary_tab
        set_deletable true
        set_icon timetable.user.icon
        timeline :"osc_lectures_#{timetable.uri}"
        active!
      end
      timetable.lectures.next { |lectures|
        timeline(:"osc_lectures_#{timetable.uri}") << lectures
      }
    end
  end
end

