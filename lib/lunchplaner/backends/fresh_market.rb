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
