# -*- coding: utf-8 -*-
require_relative 'teacher'

module Plugin::OSCTimetable
  class Lecture < Retriever::Model

    field.string :id
    field.string :title
    field.has :teacher, [Plugin::OSCTimetable::Teacher]
    field.uri :perma_link
    field.time :start
    field.time :end

    def inspect
      "#<#{self.class}: #{title} #{start}>"
    end

  end
end
