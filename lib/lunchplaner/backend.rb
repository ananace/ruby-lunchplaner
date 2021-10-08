# frozen_string_literal: true

require 'cgi'
require 'mini_cache'
require 'nokogiri'
require 'open-uri'

module Lunchplaner
  class Backend
    WEEKDAYS = %w[Söndag Måndag Tisdag Onsdag Torsdag Fredag Lördag Söndag].freeze
    MONTHS = %w[nil Januari Februari Mars April Maj Juni Juli Augusti September Oktober November December].freeze
    DAY_REX = /måndag|tisdag|onsdag|torsdag|fredag|lördag|söndag/i.freeze
    LATIN1_DETECT = "\xc3\x83\xc2\xa5"
    LATIN1_DETECT2 = "\xc3\x83\xc2\x85" # UTF-8 encoded latin-1

    def self.url(url = nil)
      @url ||= url
    end

    def url
      self.class.url
    end

    def map_search
      "#{name}, Linköping"
    end

    def links
      [
        { href: url, type: 'link', colour: 'primary', title: 'Restaurangens sida' },
        { href: "https://www.google.com/maps/search/#{CGI.escape(map_search)}", type: 'map', colour: 'THEME', title: 'Se restaurangen på karta' }
      ]
    end

    def daily
      nil
    end

    def weekly
      nil
    end

    def all
      { daily: daily, weekly: weekly }
    end

    def to_s
      self.class.name.split('::').last
    end

    def name
      to_s
    end

    def self.cache
      @cache ||= MiniCache::Store.new
    end

    protected

    def raw_data
      Backend.cache.get_or_set("raw_data-#{self.class.name}", expires_in: 1 * 60 * 60) do
        puts "Refreshing cache for #{self.class.name}..."
        Nokogiri::HTML(URI(url).open(read_timeout: 15))
      end
    end

    def data
      raw_data
    end
  end
end
