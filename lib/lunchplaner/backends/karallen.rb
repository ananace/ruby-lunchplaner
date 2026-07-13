# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Karallen < Lunchplaner::Backend
      url 'https://www.compass-group.se/restauranger-och-menyer/ovriga-restauranger/linkopings-universitet/'

      def to_s
        'Restaurang Kårallen'
      end

      def map_search
        'Restaurang Kårallen, Stratomtavägen, Linköping'
      end

      def daily
        ['"goda vällagade lunch rätter"']
      end

      def cached?
        true
      end
    end
  end
end
