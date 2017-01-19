# -*- coding: utf-8 -*-
require_relative 'lecture'

module Plugin::OSC_TimeTable
  class TimeTable < Retriever::Model

    field.string :id
    field.string :title
    field.has :lecture, [Plugin::OSC_TimeTable::Lecture]
    field.uri :url

  end
end