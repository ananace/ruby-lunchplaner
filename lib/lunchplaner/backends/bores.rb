# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Bores < Lunchplaner::Backend
      url 'https://bores.se/'

      def map_search
        'BORES, Studievägen, Linköping'
      end

      def weekly
        [data] + [
          'Orginalet/Osten/Halloumin/Kycklingen/Fiskburgaren',
          'Chefen/Tryffeln/The Bacon',
          'Osten Delux'
        ]
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

        now.at_css('.rich-text-standard > p:nth-child(2)').text
      end
    end
  end
end
