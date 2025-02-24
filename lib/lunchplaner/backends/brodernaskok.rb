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
        {
          daily: raw_data.at_css("p:contains('#{WEEKDAYS[Time.now.wday]}')").text.gsub(DAY_REX, '').sub(/ [-I|l] /, ''),
          weekly: raw_data.css('h1:contains("meny") ~ p.sqsrte-large').map(&:text)
        }
      end
    end
  end
end
