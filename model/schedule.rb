# -*- coding: utf-8 -*-

module Plugin::OSCTimetable
  class Schedule < Retriever::Model
    field.time :start, required: true
    field.time :end, required: true

    def inspect
      "#<#{self.class}: #{start} - #{self.end}>"
    end
  end
end
