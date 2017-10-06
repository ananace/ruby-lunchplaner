module Lunchplaner
  module Backends
    class Chililime < Lunchplaner::Backend
      url 'http://chili-lime.se/'

      def daily
        data.take_while do |e|
          !(e =~ /(FISK|INDISK|VEG|GRILL)/)
        end.map do |e|
          e.gsub(/[0-9A-Z]\. ?/, '')
        end.map do |e|
          e[0].upcase + e[1..-1]
        end.select do |e|
          e.length > 3
        end
      end

      def weekly
        data.drop_while do |e|
          !(e =~ /(FISK|INDISK|VEG|GRILL)/)
        end.map do |e|
          e.gsub(/([0-9A-Z]\. ?|[^;]+(\s\d+)?: |\t)/, '').split(';')
        end.flatten.select do |e| 
          e.length > 2
        end.map do |e|
          e[0].upcase + e[1..-1]
        end.select do |e|
          e.length > 3
        end
      end

      def to_s
        'Chili & Lime'
      end

      private

      def data
        @data ||= Nokogiri::HTML(open(url)).at_css('.rubrik:first').parent.css('p')[2].to_s.split('<br>')[1..-2].map do |e|
          CGI.unescapeHTML(e.strip.gsub(/\r\n\s+/, ' ')).encode 'utf-8'
        end
      end
    end
  end
end
