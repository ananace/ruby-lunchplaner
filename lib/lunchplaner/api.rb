# frozen_string_literal: true

require 'sinatra/base'

require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

class String
  def underscore
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
  end
end

class Class
  def demodularized
    name.split('::').last
  end
end

module Lunchplaner
  class API < Sinatra::Base
    # use Prometheus::Middleware::Collector
    # use Prometheus::Middleware::Exporter

    set :public_folder, 'public'

    configure :development do
      require 'sinatra/reloader'
      register Sinatra::Reloader

      also_reload 'lib/lunchplaner/backends/*.rb'
      also_reload 'lib/lunchplaner/common/*.rb'
    end

    configure :development, :production do
      enable :logging
    end

    get '/' do
      send_file File.join(settings.public_folder, 'index.html')
    end

    get '/api/?' do
      content_type :json
      { _methods: %w[/api/all /api/names /api/:backend /api/:backend/:method] }.to_json
    end

    get '/api/all/?' do
      content_type :json
      Lunchplaner.all.map do |obj|
        c = obj.delete(:source)
        next if params['open'] && !c.open?

        [c.class.demodularized.underscore, obj]
      end.sort.to_h.to_json
    end

    get '/api/names/?' do
      content_type :json
      Lunchplaner::Backends.constants.map do |c|
        next if params['open'] && !Backends.const_get(c).new.open?

        Lunchplaner::Backends.const_get(c).demodularized.underscore
      end.compact.sort.to_json
    end

    get '/api/:backend/?' do |backend|
      content_type :json
      klass = Lunchplaner::Backends.const_get(backend.split('_').map(&:capitalize).join(''))
      b = klass.new

      b.all.merge(name: b.to_s, url: b.url, links: b.links, _methods: %w[open url links name daily weekly all].map { |m| "/api/#{backend}/#{m}" }).to_json
    end

    get '/api/:backend/:method/?' do |backend, method|
      content_type :json
      raise "Invalid action '#{method}'" unless %i[open url links name daily weekly all].include?(method.to_s.to_sym)

      method = "#{method}?" if method == 'open'

      klass = Lunchplaner::Backends.const_get(backend.split('_').map(&:capitalize).join(''))
      b = klass.new
      b.send(method.to_s.to_sym).to_json
    end
  end
end
