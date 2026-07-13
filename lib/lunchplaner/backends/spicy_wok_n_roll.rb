# frozen_string_literal: true

module Lunchplaner
  module Backends
    class SpicyWokNRoll < Lunchplaner::Backend
      url 'https://spicywoknroll.se/dagens-lunch'

      def open?
        summer_start = Date.parse("#{Time.now.year}W29").to_time
        summer_end = Date.parse("#{Time.now.year}W30").to_time
        Time.now < summer_start || Time.now >= summer_end
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
          weekly = blocks.find { |b| b.at_css('h2#veckans-erbjudanden') }
                         .css('.product').map { |b| b.at_css('span').text.strip }
          daily = blocks.find { |b| b.at_xpath(".//div[contains(@class,\"summary\")]/h2[contains(text(),#{WEEKDAYS[Time.now.wday].inspect})]") }
                        .xpath('.//h3/span[not(@class)]')
                        .map { |b| b.text =~ /\Abuff.\Z/i ? b.text.strip.capitalize : b.text.sub(/^\s*[a-dA-D](?:\.\s+|\s+|\.)/, '').strip }
                        .reject(&:empty?)
        end

        { daily: daily, weekly: weekly }
      end
    end
  end
end
