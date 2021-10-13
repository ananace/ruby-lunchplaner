module Lunchplaner
  module Backends
    class SpicyWokNRoll < Lunchplaner::Backend
      url 'https://spicywoknroll.se/dagens-lunch'

      def daily
        data[:daily]
      end

      def weekly
        data[:weekly]
      end

      def to_s
        "Spicy Wok'n'Roll"
      end

      private

      def data
        blocks = raw_data.css('.productGroup')
        weekly = blocks.first.css('.product').map { |b| b.at_css('p').text.strip }
        daily = blocks.find { |b| b.at_css('.summary > h2').text.include?(WEEKDAYS[Time.now.wday]) }
                      .css('.product > h3 > span:first')
                      .map { |b| b.text.sub(/[A-Z]\.\s+/, '').strip }

        { daily: daily, weekly: weekly }
      end
    end
  end
end
