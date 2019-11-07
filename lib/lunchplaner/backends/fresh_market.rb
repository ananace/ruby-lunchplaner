module Lunchplaner
  module Backends
    class FreshMarket < Lunchplaner::Backend
      url 'https://www.ostgotakok.se/freshmarket/#meny'

      def to_s
        'Fresh Market by Östgötakök'
      end

      def daily
        [data]
      end

      private

      def data
        weeknum = Time.now.strftime('%W').to_i + 1
        in_week = false
        raw_data.at_css('.menu--left-content .overflow').css('p').each do |e|
          next if e.content.strip.empty?

          curday = WEEKDAYS[Time.now.wday]
          if !in_week
            in_week = true if e.content.end_with? weeknum.to_s
          elsif e.content.include?(curday)
            return e.content
                    .gsub(/^.*#{curday}/, '')
                    .split(/Måndag|Tisdag|Onsdag|Torsdag|Fredag/).first
                    .gsub(/[\u202f\u00a0]/, '')
          end
        end
      end
    end
  end
end
