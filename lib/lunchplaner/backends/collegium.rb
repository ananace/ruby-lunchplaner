module Lunchplaner
  module Backends
    class Collegium < Lunchplaner::Backend
      url 'http://collegium.kvartersmenyn.se/'

      def daily
        data.empty? ? nil : data
      end

      private

      def data
        day = nil
        cur = []
        raw_data.at_css('.meny:first').inner_html.split('<br>').each_with_object([]) do |e, a|
          if e.start_with? '<strong>'
            if (e.include?('Måndag') && Time.now.monday?)\
            || (e.include?('Tisdag') && Time.now.tuesday?)\
            || (e.include?('Onsdag') && Time.now.wednesday?)\
            || (e.include?('Torsdag') && Time.now.thursday?)\
            || (e.include?('Fredag') && Time.now.friday?)
              day = true
            end
          elsif day
            if e.empty? || e == e.upcase
              a << cur.join(' ') unless cur.empty?
              cur = []
            elsif e.start_with? '<strong>'
              day = nil
            else
              cur << e
            end
          end
        end
      end
    end
  end
end
