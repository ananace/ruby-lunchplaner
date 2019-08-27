module Lunchplaner
  module Backends
    class Husman < Lunchplaner::Backend
      url 'https://restauranghusman.se'

      def links
        weeknum = Time.now.strftime('%W').to_i + 1
        [
          { href: "https://restauranghusman.se/wp-content/uploads/#{Time.now.strftime "%Y/%m/#{weeknum}-%y"}.pdf", type: 'file-pdf-o', colour: 'primary', title: 'Hela veckans meny' }
        ] + super
      end

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
