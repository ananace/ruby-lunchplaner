module Lunchplaner
  module Backends
    class P2g < Lunchplaner::Backend
      url 'https://p2catering.se/lunchmeny/'

      def daily
        data[:daily]
      end

      def weekly
        data[:weekly]
      end

      def to_s
        'P2 Restaurang & Catering'
      end

      private

      def data
        daily = []
        at_day = false
        raw_data.at_css('.eltd-container-inner.clearfix').children.each do |e|
          if e.name == 'h3'
            at_day = false

            if e.text.strip.include?('Måndag') && Time.now.monday? ||
               e.text.strip.include?('Tisdag') && Time.now.tuesday? ||
               e.text.strip.include?('Onsdag') && Time.now.wednesday? ||
               e.text.strip.include?('Torsdag') && Time.now.thursday? ||
               e.text.strip.include?('Fredag') && Time.now.friday?
              at_day = true
            end
          elsif at_day && e.name == 'p'
            daily << e.content.strip
          end
        end

        weekly = daily.pop(5)

        { daily: daily, weekly: weekly }
      end
    end
  end
end
