# -*- coding: utf-8 -*-

module Plugin::OSCTimetable
  class Teacher < Retriever::Model
    include Retriever::Model::UserMixin

    field.string :name
    field.string :belonging

    def icon
      Plugin.filtering(:photo_filter, 'https://www.ospn.jp/favicon.ico', [])[1].first
    end

    def idname
      ''
    end

    def inspect
      "#<#{self.class}: #{name} (#{belonging})>"
    end

  end
end
