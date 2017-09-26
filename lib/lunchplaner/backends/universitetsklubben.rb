module Lunchplaner
  module Backends
    class Universitetsklubben < Lunchplaner::Backend
      url 'http://www.hors.se/restaurang/universitetsklubben/'

      def daily
        data.css('.hors-menu .row .text-left').map { |e| e.content.strip }
      end
    end
  end
end
