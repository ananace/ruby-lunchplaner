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
        if blocks.first.at_css('.summary').text.strip.downcase == 'sommarlunch'
          daily = nil
          weekly = blocks.first.css('.product').map { |b| b.at_css('span').text.strip }
        else
          weekly = blocks.first.css('.product').map { |b| b.at_css('span').text.strip }
          daily = blocks.find { |b| b.at_xpath(".//div[contains(@class,\"summary\")]/h2[contains(text(),#{WEEKDAYS[Time.now.wday].inspect})]") }
                        .xpath('.//h3/span[not(@class)]')
                        .map { |b| b.text =~ /\Abuffe\Z/i ? b.text.strip.capitalize : b.text.sub(/^\s*\w\.?\s*/, '').strip }
                        .reject(&:empty?)
        end

        { daily: daily, weekly: weekly }
      end
    end
  end
end
