module Lunchplaner
  module Backends
    class Collegium < Lunchplaner::Backend
      url 'http://www.sodexomeetings.se/collegium/restaurang-och-cafe/lunchmeny/'

      def daily
        data.empty? ? nil : data
      end

      private

      def data
        day = nil
        cur = []
        raw_data.at_css('.column_page').css('p')[3..-3].each do |e|
          e = e.text
          if (e.include?('Måndag') && Time.now.monday?)\
            || (e.include?('Tisdag') && Time.now.tuesday?)\
            || (e.include?('Onsdag') && Time.now.wednesday?)\
            || (e.include?('Torsdag') && Time.now.thursday?)\
            || (e.include?('Fredag') && Time.now.friday?)
            day = true
          elsif day
            day = nil
            if e.empty? || e == e.upcase
              a << cur.join(' ') unless cur.empty?
              cur = []
            else
              cur += e.split("\n").map { |entr| entr.split[1..-1].join ' ' }
            end
          end
        end

        cur
      end
    end
  end
end
