module Lunchplaner
  module Backends
    class BrodernasKok < Lunchplaner::Backend
      url 'https://brodernaskok.se/lunchmeny/'

      def daily
        data[:daily]
      end

      def to_s
        'Brödernas Kök'
      end

      private

      def data
        curday = WEEKDAYS[Time.now.wday].downcase

        hassoup = raw_data.css('style').last.text !~ /\.soppa.*display:.*none/
        atday = false
        raw_data.at_css('.day > .x-column')
                .children
                .reject { |b| b.text.empty? || b.attribute('class').nil? }
                .each_with_object({}) do |e, h|
          if e.attribute('class').text.include?('day-title')
            break h if atday # Reached the next day, stop scanning

            atday = e.text.downcase.start_with?(curday)
          elsif e.attribute('class').text.include?('dish') && atday
            puts e.inspect
            next h if e.attribute('class').text.include?('soppa') && !hassoup

            h[:daily] = [] unless h[:daily]
            h[:daily] << e.content.strip
          end
        end
      end
    end
  end
end
