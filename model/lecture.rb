# -*- coding: utf-8 -*-
require_relative 'teacher'
require_relative 'timetable'

module Plugin::OSCTimetable
  class Lecture < Retriever::Model
    include Retriever::Model::MessageMixin

    field.string :id
    field.string :title
    field.has :teachers, [Plugin::OSCTimetable::Teacher], required: true
    field.uri :perma_link
    field.has :timetable, Plugin::OSCTimetable::Timetable, required: true
    field.time :start
    field.time :end

    def user
      pp teachers
      (teachers || []).first || timetable.user
    end

    def description
      title
    end

    def created
      start
    end

    def inspect
      "#<#{self.class}: #{title} #{start} #{teachers.inspect}>"
    end

  end
end
