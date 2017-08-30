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

    def to_title
      self.class.name
    end
  end
end
