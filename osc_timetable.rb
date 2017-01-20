# -*- coding: utf-8 -*-
require 'httpclient'
require 'nokogiri'
require 'pp'

require_relative 'model'

Plugin.create(:osc_timetable) do


  def parse_table(table)
    Thread.new (table) { |t|
      table_title = t.css('caption').text
      places = t.css('tr').first.css('th').map { |th| th.text.gsub(/(\s|　)+/, '') }
      t.css('tr').first.remove

      puts "#{table_title}, places: #{places}"

      lectures = []
      t.css('tr').each do |lec|
        period = lec.css('th').text.gsub(/(\s|　)+/, '')
        start_time = period.gsub(/-[0-9:]+/, '')
        end_time = period.gsub(/[0-9:]+-/, '')

        lec.css('td').each do |l|
          next if l.css('a').first.to_s.empty?

          link = l.css('a').first[:href]
          id = link.match(/[\w\-]+\?eid=([0-9]).*/)
          title = l.css('a').first.text
          belonging = l.text.split(/\r/)[0].gsub(/.*担当：/, '')
          t_name = l.text.split(/\r/)[1].gsub(/^講師：/, '')

          teacher = Plugin::OSCTimetable::Teacher.new(:name => t_name,
                                                      :belonging => belonging)
          lectures << Plugin::OSCTimetable::Lecture.new(:id => id,
                                                        :title => title,
                                                        :teacher => teacher,
                                                        :url => link,
                                                        :start => start_time,
                                                        :end => end_time)
        end
      end

      Plugin::OSCTimetable::Timetable.new(:title => table_title,
                                          :lecture => lectures,
                                          :url => '')
    }
  end


  def timetable(year, place, part)
    Thread.new {
      client = HTTPClient.new
      url = 'https://www.ospn.jp/osc%{year}-%{place}/modules/eventrsv/index.php?id=%{part}' % {year: year, place: place, part: part}
      client.get(url)
    }.next { |response|
      charset = response.body_encoding.name
      Nokogiri::HTML.parse(response.content, nil, charset)
    }.next { |doc|
      table = doc.xpath("//table[@class='outer']").first
      p parse_table(table)
    }
  end

  Plugin::OSCTimetable::OSC['https://www.ospn.jp/osc2017-osaka/'].timetables.next{|timetables|
    pp timetables
  }
end

