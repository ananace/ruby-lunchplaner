# frozen_string_literal: true

require 'sinatra/base'

require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

class String
  def underscore
    gsub('::', '/')
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
      end.compact.sort.to_h.to_json
    end

    get '/api/restaurants/?' do
      content_type :json
      Lunchplaner::Backends.constants.map do |c|
        r = Backends.const_get(c).new
        next if params['open'] && !r.open?

        [
          r.class.demodularized.underscore,
          restaurant_info(r)
        ]
      end.compact.to_h.to_json
    end

    get '/api/restaurant/:backend/?' do |backend|
      content_type :json
      klass = Lunchplaner::Backends.const_get(backend.split('_').map(&:capitalize).join)
      b = klass.new

      b.all.merge(restaurant_info(b)).to_json
    end

    get '/api/restaurant/:backend/info/?' do |backend|
      content_type :json
      klass = Lunchplaner::Backends.const_get(backend.split('_').map(&:capitalize).join)
      b = klass.new

      restaurant_info(b).to_json
    end

    get '/api/restaurant/:backend/:method/?' do |backend, method|
      content_type :json
      raise "Invalid action '#{method}'" unless %i[open url links name daily weekly all].include?(method.to_s.to_sym)

      method = "#{method}?" if method == 'open'

      klass = Lunchplaner::Backends.const_get(backend.split('_').map(&:capitalize).join)
      b = klass.new
      b.send(method.to_s.to_sym).to_json
    end

    private

    def restaurant_info(rest)
      {
        name: rest.to_s,
        open: rest.open?,
        url: rest.url,
        links: rest.links,
        _methods: %w[info name open url links daily weekly all].map { |m| "/api/restaurant/#{rest.class.demodularized.underscore}/#{m}" }
      }
    end
  end
end
