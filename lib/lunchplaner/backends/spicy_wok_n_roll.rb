# frozen_string_literal: true

module Lunchplaner
  module Backends
    class SpicyWokNRoll < Lunchplaner::Backend
      url 'https://spicywoknroll.se/dagens-lunch'

      def open?
        Time.now > Time.parse('2023-07-23')
      end

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
        weekly = blocks.first.css('.product').map { |b| b.at_css('span').text.strip }
        daily = blocks.find { |b| b.at_xpath(".//div[contains(@class,\"summary\")]/h2[contains(text(),#{WEEKDAYS[Time.now.wday].inspect})]") }
                      .xpath('.//h3/span[not(@class)]')
                      .map { |b| b.text.sub(/^\s*\w\.?\s*/, '').strip }

        { daily: daily, weekly: weekly }
      end
    end
  end
end
