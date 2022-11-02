# frozen_string_literal: true

module Lunchplaner
  module Backends
    class FreshMarket < Lunchplaner::Backend
      url 'https://www.ostgotakok.se/freshmarket/#meny'

      def open?
        Time.now > Time.parse('2022-08-15')
      end

      def to_s
        'Fresh Market by Östgötakök'
      end

      def map_search
        'Studenthuset, Linköpings universitet, Linköping'
      end

      def daily
        today = [data].compact
        return today unless today.empty?

        nil
      end

      def weekly
        ['Vegetarisk Lunchbuffé - animaliskt protein finns']
      end

      private

      def data
        content = raw_data.at_css('.w1200--content').content.split("\n").map(&:strip)

        curday = WEEKDAYS[Time.now.wday]
        index = content.index(curday)
        return content[index + 1] if index

        nil
      end
    end
  end
end
