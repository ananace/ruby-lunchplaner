# frozen_string_literal: true

module Lunchplaner
  module Backends
    class FreshMarket < Lunchplaner::Backend
      url 'https://www.ostgotakok.se/freshmarket/#meny'

      def to_s
        'Fresh Market by Östgötakök'
      end

      def map_search
        'Studenthuset, Linköpings universitet, Linköping'
      end

      def daily
        data + [
          'Dagens soppa'
        ]
      end

      def weekly
        %w[
          Bowl
          Falafel
        ]
      end

      private

      def data
        content = raw_data.at_css('.menu--left-content > .overflow').content.split("\n").map(&:strip)
        curday = WEEKDAYS[Time.now.wday]
        index = content.index(curday)
        if index
          content[index + 1, 2]
        else
          raw_data.at_css('.menu--left-content > .overflow').css('p').each do |e|
            next if e.content.strip.empty?

            bold = e.at_css('b')
            next unless bold
            next unless bold.content.include?(curday)

            return e.text
                    .sub(DAY_REX, '')
                    .split("\n")
                    .map(&:strip)
                    .reject(&:empty?)
          end
        end
      end
    end
  end
end
