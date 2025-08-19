# frozen_string_literal: true

module Lunchplaner
  module Backends
    class DolceVita < Lunchplaner::Backend
      url 'https://dolcevitacafe.se/'

      def weekly
        [
          'Toasted Sandwich',
          'Soup',
          'Caesar Salad'
        ]
      end

      def map_search
        'Dolce Vita Fika, Linköping'
      end

      def cached?
        true
      end

      def links
        [
          { href: 'https://dolcevitacafe.se/images/menu.png', type: 'far file-image', colour: 'primary', title: 'Meny' }
        ] + super
      end

      def to_s
        'Dolce Vita'
      end
    end
  end
end
