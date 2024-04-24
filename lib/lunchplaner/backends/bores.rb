# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Bores < Lunchplaner::Backend
      url 'https://bores.se/'

      def open?
        Time.now > Time.parse('2022-07-24')
      end

      def map_search
        'BORES, Studievägen, Linköping'
      end

      def weekly
        burg = [
          'Orginalet/Osten/Halloumin/Kycklingen/Fiskburgaren',
          'Chefen/Tryffeln/The Bacon',
          'Osten Delux'
        ]
        burg = [data] + burg if data
        burg
      end

      private

      def raw_data
        Backend.cache.get_or_set("raw_data-#{self.class.name}", expires_in: 1 * 60 * 60) do
          puts "Refreshing cache for #{self.class.name}..."
          Nokogiri::HTML(URI('https://bores.se/manadens-burgare').open(read_timeout: 15))
        end
      end

      def data
        blocks = raw_data.css('.text-image-block')

        month = MONTHS[Time.now.month].downcase
        now = blocks.find { |b| b.at_css('.rich-text-standard > p > strong').text.downcase.include? month }
        return unless now

        now.at_css('.rich-text-standard > p:nth-child(2)').text
      rescue StandardError => e
        puts "[Backends.Bores] When reading monthly burger; #{e.class}: #{e}"
        nil
      end
    end
  end
end
