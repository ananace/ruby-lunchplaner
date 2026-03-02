# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Karallen < Lunchplaner::Backend
      url 'https://www.compass-group.se/'

      def to_s
        'Restaurang Kårallen'
      end

      def map_search
        'Restaurang Kårallen, Stratomtavägen, Linköping'
      end

      def daily
        ['Mat av något slag, kanske?']
      end

      def cached?
        true
      end
    end
  end
end
