module Lunchplaner
  module Backends
    class Vallastaden < Lunchplaner::Backend
      url 'http://torgetvallastaden.se/'

      def daily
        [data[:daily].gsub(/ ,/, ',').gsub(/\s+/, ' ').strip]
      end

      def weekly
        data[:weekly].map do |el|
          el.gsub(/ ,/, ',')
            .gsub(/\s\d+:-/, '')
            .gsub(/\s+/, ' ')
            .strip
        end
      end

      def to_s
        'Torget Vallastaden'
      end

      private

      def data
        menu = raw_data.at_css('#meny').xpath('.//p')
        daily = menu.find do |el|
          d = el.content.split("\n")
          e = d.first

          (e.include?('Måndag') && Time.now.monday?)\
            || (e.include?('Tisdag') && Time.now.tuesday?)\
            || (e.include?('Onsdag') && Time.now.wednesday?)\
            || (e.include?('Torsdag') && Time.now.thursday?)\
            || (e.include?('Fredag') && Time.now.friday?)
        end
        daily = daily.content.split("\n")[1] if daily

        weekly = [menu.find do |el|
          el.content.include?('Veckans')
        end.content.split("\n")[1]]

        found_weekly = false
        menu.each do |el|
          unless found_weekly
            b = el
            next if !b || !b.content.include?('Serveras hela dagen')
            found_weekly = true

            c = el.content.gsub('Serveras hela dagen', '').split("\n").reject { |e| e.length < 5 }
            weekly += c if c.any?
            next
          end

          c = el.content.split("\n").reject { |e| e.length < 5 }
          if c.length > 1
            weekly += c
          elsif c.length == 1
            weekly << c[0]
          end
        end

        if weekly.length <= 1
          weekly += menu.last.children[1..-1].map(&:content).map(&:strip).reject(&:empty?)
        end

        { daily: daily, weekly: weekly }
      end
    end
  end
end
