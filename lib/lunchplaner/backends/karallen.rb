# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Karallen < Lunchplaner::Backend
      url 'https://www.compass-group.se/MatDryck/Restauranger/linkoping-malmslatt/linkopings-universitet/restauranger--cafeer/karallen/'

      def open?
        Time.now > Time.parse('2022-08-15')
      end

      def to_s
        'Restaurang Kårallen'
      end

      def map_search
        'Restaurang Kårallen, Stratomtavägen, Linköping'
      end

      def daily
        data
      end

      private

      def raw_data
        Backend.cache.get_or_set("raw_data-#{self.class.name}", expires_in: 1 * 60 * 60) do
          puts "Refreshing cache for #{self.class.name}..."
          Nokogiri::HTML(URI('https://eurest.mashie.com/public/menu/restaurang+k%C3%A5rallen/a4160fd5?country=se').open(read_timeout: 15))
        end
      end

      def data
        blocks = raw_data.css('#week-content .container-fluid.no-print')
        blocks.find { |b| b.at_css('.day-current') }.css('.day-alternative span').map(&:text)
      end
    end
  end
end
