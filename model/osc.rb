# -*- coding: utf-8 -*-
require_relative 'timetable'
require_relative 'schedule'
require_relative 'scrape_mixin'

module Plugin::OSCTimetable
  class OpenSourceConference < Retriever::Model
    include Retriever::Model::MessageMixin
    include Retriever::Model::UserMixin
    include Plugin::OSCTimetable::ScrapeMixin

    register :osc_timetable_osc, name: 'OSC'

    field.uri :perma_link, required: true
    field.string :title, required: true

    handle %r<https://www.ospn.jp/(.+?)/> do |uri|
      Plugin::OSCTimetable::OpenSourceConference[uri]
    end

    def self.[](url)
      osc = Plugin::OSCTimetable::OpenSourceConference.new(perma_link: url,
                                                           title: 'OSC')
      Delayer::Deferred.new.next {
        osc.dom.next { |doc|
          current_field = nil
          doc.css('#centerLcolumn .blockContent').first.children.each do |element|
            case element.name
              when 'strong'
                current_field = element.text
              else
                osc[current_field] = [*osc[current_field], element] if current_field
            end
          end
        }
      }.next {
        osc
      }
    end

    def idname
      perma_link.path.gsub('/', '')
    end

    def name
      title
    end

    def description
      "#{self[:日程]}\n#{self[:会場]}"
    end

    def created
      schedules.first.start
    end

    def icon
      Plugin.filtering(:photo_filter, 'https://www.ospn.jp/favicon.ico', [])[1].first
    end

    def schedules
      self[:日程].select { |element|
        element.name == 'text'
      }.map { |element|
        element.text.match(/(?:(?<year>\d{4})年)?\s*(?<month>\d+)月\s*(?<day>\d+)日\s*\((?<wod>.)\)\s*(?<start_hour>\d{1,2}):(?<start_min>\d{1,2}).(?<end_hour>\d{1,2}):(?<end_min>\d{1,2})/)
      }.to_a.compact.inject([]) { |schedules, matched|
        [*schedules,
         Plugin::OSCTimetable::Schedule.new(start: Time.new(matched['year'] || schedules.first.start.year || Time.now.year,
                                                            matched['month'],
                                                            matched['day'],
                                                            matched['start_hour'],
                                                            matched['start_min']),
                                            end: Time.new(matched['year'] || schedules.first.start.year || Time.now.year,
                                                          matched['month'],
                                                          matched['day'],
                                                          matched['end_hour'],
                                                          matched['end_min']))]
      }
    end

    def timetables
      dom.next { |doc|
        doc.css('#mainmenu .menuMain').map { |cell|
          Addressable::URI.parse(cell[:href])
        }.select { |url|
          %r<eventrsv>.match(url.path)
        }.map { |url|
          Plugin::OSCTimetable::Timetable.new(id: url.query_values['id'],
                                              title: "#{url.query_values['id']}日目",
                                              perma_link: url,
                                              osc: self)
        }
      }
    end

    def inspect
      "#<#{self.class}: #{title}>"
    end
  end
end
