module Lunchplaner
  module Backends
    class Matkultur < Lunchplaner::Backend
      url 'http://www.matkultur.net/'

      def daily
        [] #data
      end

      private

      def data
        @data ||= Nokogiri::HTML(open(url)).at_css('#site-main .tr .td')[1]
      end
    end
  end
end
