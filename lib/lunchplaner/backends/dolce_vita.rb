# frozen_string_literal: true

module Lunchplaner
  module Backends
    class DolceVita < Lunchplaner::Backend
      url 'https://www.facebook.com/dolcevitafika/'

      def daily
        return unless [0, 3, 7].include?(Time.now.wday)

        [
          'Italian Flatbread'
        ]
      end

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

      def links
        [
          { href: 'https://ace-test.rgw.ctrl-c.liu.se/dolce-vita-meny.jpg', type: 'far file-image', colour: 'primary', title: 'Meny' }
        ] + super
      end

      def to_s
        'Dolce Vita'
      end
    end
  end
end
