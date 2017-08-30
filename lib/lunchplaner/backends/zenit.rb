module Lunchplaner
  module Backends
    class Zenit < Lunchplaner::Backend
      url 'http://www.hors.se/restaurang/restaurang-zenit/'

      def daily
        data.css('.hors-menu .row .text-left')[1..-2].map(&:content)
      end

      def weekly
        data.css('.hors-menu .row .text-left').last.content
      end

      private

      def data
        @data ||= Nokogiri::HTML(open(url))
      end
    end
  end
end
