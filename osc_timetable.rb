# -*- coding: utf-8 -*-
require 'httpclient'
require 'nokogiri'
require 'pp'

require_relative 'model'

Plugin.create(:osc_timetable) do
  Plugin::OSCTimetable::OSC['https://www.ospn.jp/osc2017-osaka/'].timetables.next{|timetables|
    #pp timetables
    timetables.each do |tt|
      tt.lectures.next{|lecture|
        pp lecture
      }.trap{|err| error err }
    end
  }.trap{|err| error err }
end

