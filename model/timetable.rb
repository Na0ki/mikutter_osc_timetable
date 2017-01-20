# -*- coding: utf-8 -*-
require_relative 'lecture'

module Plugin::OSCTimetable
  class Timetable < Retriever::Model

    field.string :id
    field.string :title
    field.has :lecture, [Plugin::OSCTimetable::Lecture]
    field.uri :perma_link
  end
end
