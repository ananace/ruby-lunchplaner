# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Husman < Lunchplaner::Backend
      url 'https://restauranghusman.se'

      def open?
        summer_start = Date.parse("#{Time.now.year}W28").to_time
        summer_end = Date.parse("#{Time.now.year}W32").to_time
        Time.now < summer_start || Time.now >= summer_end
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
