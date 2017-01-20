# -*- coding: utf-8 -*-
require_relative 'lecture'

module Plugin::OSC_TimeTable
  class TimeTable < Retriever::Model

    field.string :id
    field.string :title
    field.has :lecture, [Plugin::OSCTimetable::Lecture]
    field.uri :url

  end
end