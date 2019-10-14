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
        day = nil
        week = nil
        raw_data.at_css('.__columns div[data-col=7] .block-section .block-section-container').css('h6, p').each_with_object({}) do |e, h|
          next if e.content.strip.empty?

          if day
            h[:daily] = [e.content]
            day = nil
          elsif week
            h[:weekly] = [] unless h[:weekly]
            h[:weekly] << e.content unless h[:weekly].include? e.content
            week = nil
          elsif e.content.start_with? 'Veckans '
            week = true
          elsif (e.content.start_with?('Måndag') && Time.now.monday?) \
             || (e.content.start_with?('Tisdag') && Time.now.tuesday?) \
             || (e.content.start_with?('Onsdag') && Time.now.wednesday?) \
             || (e.content.start_with?('Torsdag') && Time.now.thursday?) \
             || (e.content.start_with?('Fredag') && Time.now.friday?)
            day = true
          end
        end
      end
    end
  end
end
