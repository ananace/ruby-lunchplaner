module Lunchplaner
  module Backends
    class FreshMarket < Lunchplaner::Backend
      url 'https://www.ostgotakok.se/freshmarket/#meny'

      def to_s
        'Fresh Market by Östgötakök'
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
        raw_data.at_css('.menu--left-content > .overflow').css('p').each do |e|
          next if e.content.strip.empty?

          curday = WEEKDAYS[Time.now.wday]
          next unless e.at_css('b').content.include?(curday)

          return e.children[1..]
                  .text
                  .split("\n")
                  .map(&:strip)
        end
      end
    end
  end
end
