module Lunchplaner
  module Backends
    class Matkultur < Lunchplaner::Backend
      url 'http://www.matkultur.net/'

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
        @data ||= Nokogiri::HTML(open(url)).at_css('#site-main tr td:nth-of-type(2)').children.select{|c| c.name == 'p'}.each_with_object({}) do |e, h|
          if day
            h[:daily] = e.content
            day = nil
          elsif week
            h[:weekly] = [] unless h[:weekly]
            h[:weekly] << e.content
            week = nil
          elsif e.content.start_with? 'Veckans '
            week = true
          elsif e.inner_html.start_with? '<strong>'
            if (e.content.start_with?('Måndag') && Time.now.monday?)\
            || (e.content.start_with?('Tisdag') && Time.now.tuesday?)\
            || (e.content.start_with?('Onsdag') && Time.now.wednesday?)\
            || (e.content.start_with?('Torsdag') && Time.now.thursday?)\
            || (e.content.start_with?('Fredag') && Time.now.friday?)
              day = true
            end
          end
        end
      end
    end
  end
end
