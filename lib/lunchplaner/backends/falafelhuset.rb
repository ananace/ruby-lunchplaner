# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Falafelhuset < Lunchplaner::Backend
      url 'https://falafelhuset.se/'

      def weekly
        [
          'Falafel bröd/rulle/tallrik/sallad',
          'Shawarma bröd/rulle/tallrik/sallad',
          'Kebab bröd/rulle/tallrik/sallad',
          'Fajita rulle/tallrik/sallad',
          'Shawarma Arabi tallrik',
          'Hamburgare',
          'Sallad'
        ]
      end

      def map_search
        'Falafelhuset, Linköping Universitet'
      end

      def links
        [
          { href: 'https://ace-test.rgw.ctrl-c.liu.se/campusmenu.jpg', type: 'far file-image', colour: 'primary', title: 'Campus menyn' }
        ] + super
      end
    end
  end
end
