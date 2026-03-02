# frozen_string_literal: true

module Lunchplaner
  module Backends
    class VallastadensPizza < Lunchplaner::Backend
      url 'https://www.vallastadenspizza.se/'

      def daily
        %w[Pizza Kebab Kyckling Falafel Gyros Hamburgare Schnitzel Lasagne Sallad]
      end

      def to_s
        'Vallastadens Pizzeria'
      end

      def cached?
        true
      end
    end
  end
end
