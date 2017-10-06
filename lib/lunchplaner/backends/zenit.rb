module Lunchplaner
  module Backends
    class Zenit < Lunchplaner::Backend
      url 'http://www.hors.se/restaurang/restaurang-zenit/'

      def daily
        data.css('.hors-menu .row .text-left')[0..-2].map { |e| e.content.strip }
      end

      def weekly
        data.css('.hors-menu .row .text-left').last.content.strip.split("\n").map do |e|
          e.gsub(/.*:\W+/, '')
        end
      end
    end
  end
end
