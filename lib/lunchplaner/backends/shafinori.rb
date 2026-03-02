# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Shafinori < Lunchplaner::Backend
      url 'https://shafinori.se/meny#menu_lunch'

      def to_s
        'Sushi Shafinori'
      end

      def daily
        %w[
          Sushi
        ] + %w[Poké Yakiniku Yakitori Kyckling Grön].map { |typ| "#{typ} Bowl" }
      end

      def cached?
        true
      end
    end
  end
end
