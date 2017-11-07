module Lunchplaner
  module Backends
    class Universitetsklubben < Lunchplaner::Backend
      url 'http://www.hors.se/restaurang/universitetsklubben/'

      def daily
        data.css('.hors-menu .row .text-left').map do |e|
          e.content.strip.delete "\n"
        end
      end
    end
  end
end
