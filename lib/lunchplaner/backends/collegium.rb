module Lunchplaner
  module Backends
    class Collegium < Lunchplaner::Backend
      url 'http://collegium.kvartersmenyn.se/'

      def daily
        [] #data
      end

      private

      def data
        @data ||= Nokogiri::HTML(open(url)).at_css('.meny:first')
      end
    end
  end
end
