module Lunchplaner
  module Backends
    class Matkultur < Lunchplaner::Backend
      url 'https://www.matkultur.net/Veckans-meny.html'

      def daily
        data[:daily]
      end

      def weekly
        data[:weekly]
      end

      private

      def data
        curday = WEEKDAYS[Time.now.wday].downcase

        raw_data.css('.__columns')
          .last
          .css('div.block')
          .reject { |b| b.text.empty? }
          .select { |b| b.text =~ DAY_REX || b.text =~ /veckans/i }
          .each_with_object({}) do |e, h|
          p = e.css('p')
            
          if e.content.downcase.start_with?(curday)
            h[:daily] = [e.content.gsub("\xc2\xa0", ' ').gsub(DAY_REX, '').strip]
          elsif e.content.downcase.start_with? 'veckans '
            h[:weekly] = [] unless h[:weekly]
            h[:weekly] << e.content.gsub("\xc2\xa0", ' ').gsub(/veckans (kött|under ytan|vegetariska)/i, '').strip
          end
        end
      end
    end
  end
end
