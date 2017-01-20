# -*- coding: utf-8 -*-
require_relative 'teacher'

module Plugin::OSCTimetable
  class Lecture < Retriever::Model

    field.string :id
    field.string :title
    field.has :teacher, [Plugin::OSCTimetable::Teacher]
    field.uri :url
    field.string :start
    field.string :end

  end
end