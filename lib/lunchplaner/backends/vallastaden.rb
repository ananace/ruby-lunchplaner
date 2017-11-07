module Lunchplaner
  module Backends
    class Vallastaden < Lunchplaner::Backend
      url 'http://torgetvallastaden.se/'

      def daily
        data[:daily].gsub(/ ,/, ',')
      end

      def weekly
        data[:weekly].map { |el| el.gsub(/ ,/, ',') }
      end

      def to_s
        'Torget Vallastaden'
      end

      private

      def data
        @data ||= (
          menu = Nokogiri::HTML(open(url)).at_css('#meny').xpath('.//span')
          daily = menu.find do |el|
            b = el.at_css('b')
            next unless b
            e = b.content

            (e.include?('Måndag') && Time.now.monday?)\
              || (e.include?('Tisdag') && Time.now.tuesday?)\
              || (e.include?('Onsdag') && Time.now.wednesday?)\
              || (e.include?('Torsdag') && Time.now.thursday?)\
              || (e.include?('Fredag') && Time.now.friday?)
          end.content.split("\n")[1]

          weekly = [menu.find do |el|
            b = el.at_css('b')
            next unless b
            b.content.include?('Veckans')
          end.content.split("\n")[1]]

          found_weekly = false
          menu.each do |el|
            if !found_weekly
              b = el.at_css('b')
              next if not b or !b.content.include?('Serveras hela dagen')
              found_weekly = true
              next
            end

            c = el.content.gsub(/\s\d+:-/, '').split("\n")
            if c.length > 1
              weekly << c[1]
            else
              weekly << c[0]
            end
          end

          { daily: daily, weekly: weekly }
        )
      end
    end
  end
end
