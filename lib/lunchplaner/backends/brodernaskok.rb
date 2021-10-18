# frozen_string_literal: true

module Lunchplaner
  module Backends
    class BrodernasKok < Lunchplaner::Backend
      url 'https://brodernaskok.se/meny/'

      def daily
        data[:daily]
      end

      def weekly
        ['Plocksallad'] + data[:weekly]
      end

      def to_s
        'Brödernas Kök'
      end

      private

      def data
        blocks = raw_data.css('.menu-section')

        daily = blocks.css('.menu-item').select { |b| b.css('.menu-item-title').text.include?(WEEKDAYS[Time.now.wday]) }
        weekly = blocks.find { |b| b.at_css('.menu-section-header').text.include? 'Säsongens' }

        today = daily.map { |b| b.css('.menu-item-title').find { |i| i.text.include?(WEEKDAYS[Time.now.wday]) } }

        d = { weekly: weekly.css('.menu-item-title').map(&:text) }
        return d if today.empty?

        d[:daily] = today.compact.map { |i| i.text.gsub(DAY_REX, '').sub(/ [-I] /, '') }
        d
      end
    end
  end
end
