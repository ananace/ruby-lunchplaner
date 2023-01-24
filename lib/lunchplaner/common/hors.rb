# frozen_string_literal: true

module Lunchplaner
  module Common
    module Hors
      def daily
        data
      end

      def open?
        Time.parse('2022-06-23 23:59') >= Time.now || Time.now >= Time.parse('2022-08-15 00:00')
      end

      protected

      def data
        correct_week = raw_data.at_css('#current') || raw_data
        items = correct_week.at_css('.menu-container .menu-col')
        return nil unless items

        day = Time.now.wday
        return nil if day.negative? || day > 4

        broken_encoding = items.content.include?(Lunchplaner::Backend::LATIN1_DETECT) ||
                          items.content.include?(Lunchplaner::Backend::LATIN1_DETECT2)

        wday = Lunchplaner::Backend::WEEKDAYS_EN[day].downcase
        content = items.css(".#{wday} p").map(&:content)
        content = items.css(".menu-item:nth-child(#{day}) p").map(&:content) if content.empty?

        content.map! { |c| c.encode('ISO-8859-1', 'UTF-8').tap { |mc| mc.force_encoding('UTF-8') } } if broken_encoding
        content.map(&:strip)
      end
    end
  end
end
