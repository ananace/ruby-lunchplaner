module Lunchplaner
  module Backends
    class BrodernasKok < Lunchplaner::Backend
      url 'https://brodernaskok.se/meny/'

      def weekly
        data[:weekly]
      end

      def to_s
        'Brödernas Kök'
      end

      private

      def data
        { weekly: raw_data.at_css('.menu-section').css('.menu-item-title').map { |e| e.text } }
      end
    end
  end
end
