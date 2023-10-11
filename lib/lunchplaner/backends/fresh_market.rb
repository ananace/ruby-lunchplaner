# frozen_string_literal: true

module Lunchplaner
  module Backends
    class FreshMarket < Lunchplaner::Backend
      url 'https://freshmarket.ostgotakok.se/lunchmeny/'

      def open?
        Time.now > Time.parse('2023-08-15')
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
        content = raw_data.at_css('div:has(#menyblock)').css('h3 ~ p, h4 ~ p').map(&:content)
        content[Time.now.wday - 1]
      end
    end
  end
end
