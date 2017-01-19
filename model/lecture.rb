# -*- coding: utf-8 -*-
require_relative 'teacher'

module Plugin::OSC_TimeTable
  class Lecture < Retriever::Model

    field.string :id
    field.string :title
    field.has :teacher, Plugin::OSC_TimeTable::Teacher
    field.uri :url
    field.string :start
    field.string :end

  end
end