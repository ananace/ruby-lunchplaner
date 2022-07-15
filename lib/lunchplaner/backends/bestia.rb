# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Bestia < Lunchplaner::Backend
      url 'https://bestialkpg.se/'

      def to_s
        'BESTIA'
      end

      def open?
        Time.now.friday?
      end

      def daily
        %w[
          Pasta
          Pizza
          Grillat
        ]
      end
    end
  end
end
