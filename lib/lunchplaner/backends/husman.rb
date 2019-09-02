module Lunchplaner
  module Backends
    class Husman < Lunchplaner::Backend
      url 'https://restauranghusman.se'

      def links
        # The official download URL scheme; (The restaurant doesn't always follow it)
        # weeknum = Time.now.strftime('%W').to_i + 1
        # weekly_url = "https://restauranghusman.se/wp-content/uploads/#{Time.now.strftime "%Y/%m/#{weeknum}-%y"}.pdf"
        
        weekly_url = data.css('a.btn').first['href']

        [
          { href: weekly_url, type: 'file-pdf-o', colour: 'primary', title: 'Hela veckans meny' }
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
