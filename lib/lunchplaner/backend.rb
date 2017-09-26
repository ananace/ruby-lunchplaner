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
      self.class.name.split(':').last
    end

    protected

    def data
      @data ||= Nokogiri::HTML(open(url))
    end
  end
end
