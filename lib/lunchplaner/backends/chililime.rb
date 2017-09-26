module Lunchplaner
  module Backends
    class Chililime < Lunchplaner::Backend
      url 'http://chili-lime.se/'

      def daily
        [] #data
      end

      def weekly
        ['Asiatisk Buffé']
      end

      def to_s
        'Chili & Lime'
      end

      private

      def data
        @data ||= Nokogiri::HTML(open(url)).at_css('.rubrik:first').parent.css('p')[2]
      end
    end
  end
end
