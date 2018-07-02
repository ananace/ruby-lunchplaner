module Lunchplaner
  module Backends
    class P2g < Lunchplaner::Backend
      url 'http://p2catering.se/'

      def daily
        data
      end

      def to_s
        'P2 Restaurang & Catering'
      end

      private

      def data
        raw_data.at_css('.wpb_wrapper h3').parent.css('p').map do |e|
          e.content.strip
        end.reject(&:empty?)
      end
    end
  end
end
