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
    end
    Plugin::OSCTimetable::OpenSourceConference['https://www.ospn.jp/osc2017-osaka/'].next{|osc|
      timeline(:osc_list) << osc
    }
  end

  intent Plugin::OSCTimetable::OpenSourceConference, label: 'OSC' do |intent_token|
    osc = intent_token.model
    tab(:"osc_#{osc.idname}", osc.name) do
      temporary_tab
      set_deletable true
      timeline(:"osc_#{osc.idname}_timetables")
    end
    osc.timetables.next{|tts|
      timeline(:"osc_#{osc.idname}_timetables") << tts
    }.trap{|err| error err }
  end

  intent Plugin::OSCTimetable::Timetable, label: 'OSCタイムテーブル' do |intent_token|
    timetable = intent_token.model
    tab(:"osc_lectures_#{timetable.uri}", timetable.title) do
      temporary_tab
      set_deletable true
      timeline :"osc_lectures_#{timetable.uri}"
    end
    timetable.lectures.next{|lectures|
      timeline(:"osc_lectures_#{timetable.uri}") << lectures
    }
  end
end

