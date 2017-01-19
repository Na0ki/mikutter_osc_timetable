# -*- coding: utf-8 -*-
require 'slim'
require 'active_record'
require 'sinatra'
require 'sinatra/reloader'

module Plugin::OSC_OSAKA_2017

  class Topic < ActiveRecord::Base
  end


  class REST < ActiveRecord::Base

    attr_reader :server

    def initialize
      ActiveRecord::Base.configurations = YAML.load_file(File.join(__dir__, 'db.yml'))
      ActiveRecord::Base.establish_connection('development')
    end

    @server = Sinatra.new {
      set(:port => 8080)

      get('/') do
        slim(:index)
      end

      get('/:venue/:year/timetable/:day') do |venue, year, day|
        content_type :json, :charset => 'utf-8'
        'venue: %{venue}, year: %{year}, day: %{day}' % {venue: venue, year: year, day: day}
        # TODO: DB Access
      end


      not_found do |_|
        'Request Path is Not Found: %{path}' %{path: request.path}
      end


      error do
        'Error is: %{e}' % {e: params['captures'].first.inspect}
      end
    }

  end

end