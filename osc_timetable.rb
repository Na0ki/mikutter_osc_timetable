# -*- coding: utf-8 -*-
require 'httpclient'
require 'nokogiri'
require 'pp'

require_relative 'model'

Plugin.create(:osc_timetable) do
  command(:osc,
          name: 'OSC',
          condition: lambda{ |opt| true },
          visible: true,
          icon: get_skin('osc.gif'),
          role: :window) do |opt|
    tab(:osc, "OSC") do
      temporary_tab
      set_deletable true
      timeline :osc_list
      active!
    end
    Plugin::OSCTimetable::OpenSourceConference['https://www.ospn.jp/osc2017-osaka/'].next{|osc|
      timeline(:osc_list) << osc
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
        timeline(:"osc_#{osc.idname}_timetables")
        active!
      end
      osc.timetables.next{|tts|
        timeline(:"osc_#{osc.idname}_timetables") << tts
      }.trap{|err| error err }
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
        timeline :"osc_lectures_#{timetable.uri}"
        active!
      end
      timetable.lectures.next{|lectures|
        timeline(:"osc_lectures_#{timetable.uri}") << lectures
      }
    end
  end
end

