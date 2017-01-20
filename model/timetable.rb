# -*- coding: utf-8 -*-
require_relative 'lecture'
require_relative 'scrape_mixin'

module Plugin::OSCTimetable
  class Timetable < Retriever::Model
    include Plugin::OSCTimetable::ScrapeMixin

    field.string :id
    field.string :title
    field.uri :perma_link

    def lectures
      dom.next do |doc|
        parse_table(doc.xpath("//table[@class='outer']").first)
      end
    end

    def inspect
      "#<#{self.class}: #{title}>"
    end

    private

    def parse_table(table)
      table_title = table.css('caption').text
      places = table.css('tr').first.css('th').map { |th| th.text.gsub(/(\s|　)+/, '') }
      table.css('tr').first.remove

      table.css('tr').map do |lec|
        period = lec.css('th').text.gsub(/(\s|　)+/, '')
        start_time = period.gsub(/-[0-9:]+/, '')
        end_time = period.gsub(/[0-9:]+-/, '')

        lec.css('td').reject{|l|
          l.css('a').first.to_s.empty?
        }.map do |l|
          link = l.css('a').first[:href]
          id = link.match(/[\w\-]+\?eid=([0-9]).*/)
          title = l.css('a').first.text
          belonging = l.text.split(/\r/)[0].gsub(/.*担当：/, '')
          t_name = l.text.split(/\r/)[1].gsub(/^講師：/, '')

          teacher = Plugin::OSCTimetable::Teacher.new(:name => t_name,
                                                      :belonging => belonging)
          Plugin::OSCTimetable::Lecture.new(:id => id,
                                            :title => title,
                                            :teacher => [teacher],
                                            :url => link,
                                            :start => start_time,
                                            :end => end_time)
        end
      end
    end

  end
end
