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
        result = []
        raw_data.at_css('.column_page').css('p').each do |e|
          e = e.text
          if %w[måndag tisdag onsdag torsdag fredag].include? e.strip.downcase
            if (e.include?('Måndag') && Time.now.monday?)\
              || (e.include?('Tisdag') && Time.now.tuesday?)\
              || (e.include?('Onsdag') && Time.now.wednesday?)\
              || (e.include?('Torsdag') && Time.now.thursday?)\
              || (e.include?('Fredag') && Time.now.friday?)
              day = true
            else
              day = false
            end

            result << cur.join(' ') unless cur.empty?
            cur = []
          elsif day
            if e == e.upcase
              result << cur.join(' ') unless cur.empty?
              cur = []
            elsif e.empty? || e.include?(':-') || e.include?('.-')
              result << cur.join(' ') unless cur.empty?
              cur = []

              day = nil
            else
              cur += e.split("\n").reject(&:empty?)
            end
          end
        end

        result
      end
    end
  end
end
