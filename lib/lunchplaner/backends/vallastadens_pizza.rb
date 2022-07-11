# frozen_string_literal: true

module Lunchplaner
  module Backends
    class VallastadensPizza < Lunchplaner::Backend
      url 'http://www.vallastadenspizza.se/index.html'

      def weekly
        data[:weekly]
      end

      def to_s
        'Vallastadens Pizza'
      end

      private

      def data
        weekly = raw_data.at_css('.layout-cell.layout-item-1 > h4').inner_html.split('<br>').map { |t| t.sub('•', '').strip }
        { weekly: weekly }
      end
    end
  end
end
