# frozen_string_literal: true

require 'sinatra/base'

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
    set :public_folder, 'public'
    set :views, 'views'

    set :erb, trim: '-'

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
      backends = Lunchplaner::Backends.constants.sort.map { |c| Backends.const_get(c).new }
      backends = backends.select!(&:open?) if params.key?('open')

      if params['num']
        count = params['num'].to_i
        page = (params['page'] || '0').to_i

        backends = backends[(page * count), count]
      end

      locals = {}
      locals[:theme] = request.cookies.fetch('theme', 'light')
      locals[:theme] = 'dark' if params.key?('dark')

      erb :index, locals: locals do
        backends.map do |backend|
          clean_name = backend.clean_name

          erb :backend, locals: {
            backend: backend,
            clean_name: clean_name
          }
        end.join "\n"
      end
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
