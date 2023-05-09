# frozen_string_literal: true

module Lunchplaner
  module Backends
    class TomiSushi < Lunchplaner::Backend
      url 'https://instagram.com/tomi.sushi_vallastaden'

      def weekly
        %w[
          Sushi
          Maki
          Yakiniku
          Pankokyckling
          Bibimbap
          Nudelwok
          Pokebowl
        ]
      end

      def to_s
        'Tomi Sushi'
      end

      def open?
        !Time.now.monday?
      end

      def links
        [
          { href: 'https://ace-test.rgw.ctrl-c.liu.se/tomi_sushi.jpg', type: 'far file-image', colour: 'primary', title: 'Lunch menyn' }
        ] + super
      end
    end
  end
end
