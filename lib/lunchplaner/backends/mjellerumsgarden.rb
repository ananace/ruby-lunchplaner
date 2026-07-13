# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Mjellerumsgarden < Lunchplaner::Backend
      url 'https://www.mjellerum.se/meny/lunch/'

      def daily
        data[:daily]
      end

      def weekly
        data[:weekly]
      end

      def links
        return super unless sommarmeny?

        [
          { href: 'https://mjellerum.se/custom/uploads/2026/07/Sommarmeny-2026-ratta.png', type: 'far file-image', colour: 'primary', title: 'Sommarmeny' }
        ] + super
      end

      def to_s
        'Mjellerumsgården'
      end

      def sommarmeny?
        summer_start = Date.parse("#{Time.now.year}W26").to_time
        # FIXME: Find correct end-week
        summer_end = Date.parse("#{Time.now.year}W42").to_time
        Time.now >= summer_start && Time.now < summer_end
      end

      def cached?
        sommarmeny?
      end

      private

      def data
        if sommarmeny?
          return {
            weekly: [
              'Räkmacka',
              'Skagenmacka',
              'Ryggbiffmacka',
              'Köttbullar',
              'Bakad lax',
              'Bakad spetskål',
              'Sallader'
            ]
          }
        end

        {}
      end
    end
  end
end
