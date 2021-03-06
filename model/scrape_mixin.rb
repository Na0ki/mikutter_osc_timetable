# -*- coding: utf-8 -*-

module Plugin::OSCTimetable
  module ScrapeMixin
    def dom
      html.next do |response|
        Nokogiri::HTML.parse(response.content, nil, response.body_encoding.name)
      end
    end

    def html
      Thread.new { html! }
    end

    private

    memoize def html!
      client = HTTPClient.new
      client.get(perma_link, follow_redirect: true)
    end
  end
end
