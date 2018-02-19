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
        raw_data.at_css('.meny:first').inner_html.split('<br>').each_with_object([]) do |e, a|
          if day
            if e.empty?
              day = nil
            else
              a << e unless %w[HAV GÅRD ÄNG SALLAD].include? e
            end
          elsif e.start_with? '<strong>'
            if (e.include?('Måndag') && Time.now.monday?)\
            || (e.include?('Tisdag') && Time.now.tuesday?)\
            || (e.include?('Onsdag') && Time.now.wednesday?)\
            || (e.include?('Torsdag') && Time.now.thursday?)\
            || (e.include?('Fredag') && Time.now.friday?)
              day = true
            end
          end
        end
      end
    end
  end
end
