# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Husman < Lunchplaner::Backend
      url 'https://restauranghusman.se'

      def open?
        Time.now > Time.parse('2022-08-08')
      end

      def to_s
        'Restaurang Husman'
      end

      def daily
        data.css('.jedv-enabled--yes div.e-con-full:not(.elementor-hidden-mobile) span.elementor-heading-title.elementor-size-default').map do |e|
          e.content.strip.delete "\n"
        end
      end
    end
  end
end
