require 'mini_cache'
require 'nokogiri'
require 'open-uri'

module Lunchplaner
  class Backend
    def self.url(url = nil)
      @url ||= url
    end

    def url
      self.class.url
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

    protected

    def cache
      @cache ||= MiniCache::Store.new
    end

    def raw_data
      cache.get_or_set("raw_data-#{self.class.name}", expires_in: 1 * 60 * 60) do
        puts "Refreshing cache for #{self.class.name}..."
        Nokogiri::HTML(URI(url).open(read_timeout: 15))
      end
    end

    def data
      raw_data
    end
  end
end
