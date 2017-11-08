module Lunchplaner
  module Backends
    class P2G < Lunchplaner::Backend
      url 'http://p2catering.se/'

      def daily
        data
      end

      def to_s
        'P2 Restaurang & Catering'
      end

      private

      def data
        @data ||= Nokogiri::HTML(open(url)).at_css('.wpb_wrapper h3').parent.css('p').map do |e|
          e.content.strip
        end.select { |d| !d.empty? }
      end
    end
  end
end
