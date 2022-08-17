# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Karallen < Lunchplaner::Backend
      url 'https://www.compass-group.se/MatDryck/Restauranger/linkoping-malmslatt/linkopings-universitet/restauranger--cafeer/karallen/'

      def open?
        Time.now > Time.parse('2022-08-22') && !data.nil?
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
        days = raw_data.css('#week-content .container-fluid.no-print').map do |b|
          {
            day: b.at_css('.day-date span').attribute('js-date').value,
            meals: b.css('.day-alternative span').map(&:text)
          }
        end

        days.find { |d| d[:day] == Time.now.strftime('%Y-%m-%d') }&.[](:meals)
      end
    end
  end
end
