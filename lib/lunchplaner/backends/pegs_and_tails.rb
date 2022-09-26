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
        sections = raw_data.css('section.sektion2 > div > div > .elementor-widget-wrap.elementor-element-populated > section:not(.elementor-hidden-desktop)')
        strings = sections.map { |b| b.text.sub(/\d+:-/, '').strip }.reject(&:empty?)

        daily = []
        daily << "#{strings.shift} - #{strings.shift}"
        daily << "#{strings.shift} - #{strings.shift}"
        weekly = []
        until strings.empty?
          weekly << "#{strings.shift} - #{strings.shift}"
        end

        { daily: daily, weekly: weekly }
      end
    end
  end
end
