# frozen_string_literal: true

module Lunchplaner
  module Backends
    class PegsAndTails < Lunchplaner::Backend
      url 'https://www.pegsandtails.se/lunch/'

      def daily
        data[:daily]
      end

      def weekly
        data[:weekly]
      end

      def to_s
        'Pegs & Tails'
      end

      private

      def data
        sections = raw_data.css('section.sektion2 > div > div > .elementor-widget-wrap.elementor-element-populated > *')

        daily = []
        weekly = []

        cur = []
        target = 0
        sections.each do |sect|
          if sect.name == 'div'
            target += 1 if sect.classes.include? 'elementor-widget-divider'
            next
          end

          if (title = sect.at_css('.meny-titel'))
            cur << title.text.strip
          elsif sect.classes.include? 'elementor-hidden-desktop'
            cur = cur.reject(&:empty?).compact
            next if cur.empty?

            if target == 1
              daily << cur.join(' - ')
            else
              weekly << cur.join(' - ')
            end
            cur = []
          else
            ingredients = sect.at_css('.meny-innehall').text.gsub(/\s+/, ' ').strip
            allergens = sect.at_css('.meny-allergi').text.strip
            ingredients += " (#{allergens})" unless allergens.empty?
            cur << ingredients
          end
        end

        { daily: daily, weekly: weekly }
      end
    end
  end
end
