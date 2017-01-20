# -*- coding: utf-8 -*-

module Plugin::OSCTimetable
  class OSC < Retriever::Model
    include Retriever::Model::MessageMixin
    include Retriever::Model::UserMixin

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

    def dom
      html.next do |response|
        charset = response.body_encoding.name
        Nokogiri::HTML.parse(response.content, nil, charset)
      end
    end

    def html
      Thread.new { html! }
    end

    private

    memoize def html!
      client = HTTPClient.new
      client.get(perma_link)
    end
  end
end
