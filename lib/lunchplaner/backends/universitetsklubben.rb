module Lunchplaner
  module Backends
    class Universitetsklubben < Lunchplaner::Backend
      url 'http://www.hors.se/restaurang/universitetsklubben/'

      def links
        [
          { href: "http://www.hors.se/veckans-meny/?week_for=#{Time.now.strftime '%Y-%m-%d'}&rest=179", type: 'calendar', colour: 'primary', title: 'Hela veckans meny' }
        ] + super
      end

      def daily
        data.css('.hors-menu .row .text-left').map do |e|
          e.content.strip.delete "\n"
        end
      end
    end
  end
end
