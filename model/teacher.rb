# -*- coding: utf-8 -*-

module Plugin::OSCTimetable
  class Teacher < Retriever::Model

    field.string :name
    field.string :belonging

    def inspect
      "#<#{self.class}: #{name} (#{belonging})>"
    end

  end
end
