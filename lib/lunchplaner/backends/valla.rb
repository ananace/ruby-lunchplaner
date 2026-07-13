# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Valla < Lunchplaner::Backend
      url 'https://valla.nu/restaurang/'

      def open?
        summer_start = Date.parse("#{Time.now.year}W28").to_time
        summer_end = Date.parse("#{Time.now.year}W32").to_time
        Time.now < summer_start || Time.now >= summer_end
      end

      def to_s
        'Valla Folkhögskola'
      end

      def daily
        data.css('div.elementor-widget-wrap.elementor-element-populated').each do |e|
          header = e.at_css('div[data-widget_type="heading.default"]')
          next unless header&.text&.strip&.include? 'Dagens lunch'

          return e.css('div.elementor-element').last.css('p')[0,2].map { |p| p.text }
        end
      end
    end
  end
end
