# frozen_string_literal: true

module Lunchplaner
  module Common
    module Hors
      def daily
        data
      end

      protected

      def data
        correct_week = raw_data.at_css('#current')
        correct_week ||= raw_data

        items = correct_week.css('.menu-container .menu-col .menu-item')
        day = Time.now.wday - 1
        broken_encoding = items.any? do |item|
          item.content.include?(Lunchplaner::Backend::LATIN1_DETECT) ||
            item.content.include?(Lunchplaner::Backend::LATIN1_DETECT2)
        end

        return [] if day.negative? || day > 4

        content = items[day].content
        content = content.encode('ISO-8859-1', 'UTF-8').tap { |c| c.force_encoding('UTF-8') } if broken_encoding
        content.strip
               .split("\n")
               .reject { |c| c =~ Lunchplaner::Backend::DAY_REX }
               .reject { |c| c.length < 5 }
               .map(&:strip)
      end
    end
  end
end
