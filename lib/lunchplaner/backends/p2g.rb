module Lunchplaner
  module Backends
    class P2g < Lunchplaner::Backend
      url 'https://p2catering.se/lunchmeny/'

      def daily
        data[:daily]
      end

      def weekly
        data[:weekly]
      end

      def to_s
        'P2 Restaurang & Catering'
      end

      private

      def data
        block = raw_data
                .css('.full-width-all > .block-section-container > .block-columns > div > .block-section > .block-section-container')
                .find do |b|
          b.at_css('.block-header').text.strip.include?(WEEKDAYS[Time.now.wday])
        end

        daily = block.css('p').map { |e| e.text.gsub(/\d+ kr/, '').strip }
        weekly = daily.pop(5)

        { daily: daily, weekly: weekly }
      end
    end
  end
end
