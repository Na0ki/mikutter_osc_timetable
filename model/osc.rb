# -*- coding: utf-8 -*-
require_relative 'timetable'
require_relative 'scrape_mixin'

module Plugin::OSCTimetable
  class OSC < Retriever::Model
    include Retriever::Model::MessageMixin
    include Plugin::OSCTimetable::ScrapeMixin

    register :osc_timetable_osc, name: "OSC"

    field.uri :perma_link, required: true
    field.string :title, required: true
    #field.has :timetable, [Plugin::OSC_TimeTable], required: true

    def self.[](url)
      osc = Plugin::OSCTimetable::OSC.new(perma_link: url,
                                          title: 'OSC',
                                          timetable: [])
      osc
    end

    def timetables
      dom.next{|doc|
        doc.css('#mainmenu .menuMain').map{|cell|
          Addressable::URI.parse(cell[:href])
        }.select{ |url|
          %r<eventrsv>.match(url.path)
        }.map{|url|
          Plugin::OSCTimetable::Timetable.new(id: url.query_values['id'],
                                              title: "#{url.query_values['id']}日目",
                                              perma_link: url)
        }
      }
    end
  end
end
