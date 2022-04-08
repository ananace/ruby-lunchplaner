# frozen_string_literal: true

module Lunchplaner
  module Backends
    class LaFontana < Lunchplaner::Backend
      url 'https://lafontanamjardevi.se/dagens-lunch/'

      def daily
        data
      end

      def weekly
        %w[Pizza Sallad Kebab]
      end

      def to_s
        'La Fontana Mjärdevi'
      end

      private

      def data
        raw_data.css('.elementor-price-list-description')[Time.now.wday - 1].content.split("\n")
      end
    end
  end
end
