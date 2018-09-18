module Lunchplaner
  module Backends
    class Husman < Lunchplaner::Backend
      url 'https://restauranghusman.se'

      def to_s
        'Restaurang Husman'
      end

      def daily
        data.css('.todays-menu ul li').reject { |e| e.content =~ /V.lkommen!/ }.map do |e|
          e.content.strip.delete "\n"
        end
      end
    end
  end
end
