# frozen_string_literal: true

module Lunchplaner
  module Backends
    class LaFontana < Lunchplaner::Backend
      url 'https://lafontanamjardevi.se/dagens-lunch/'

      def daily
        data[:daily]
      end

      def weekly
        (data[:weekly] || []) + %w[Pizza Sallad Kebab]
      end

      def to_s
        'La Fontana Mjärdevi'
      end

      private

      def data
        if raw_data.at_css('.elementor-price-list-title').text =~ /^måndag till fredag/i
          entries = raw_data
                    .at_css('.elementor-price-list-description + div')
                    .css('div')
                    .map { |e| e.text.strip.sub("\n", ' — ') }
                    .reject(&:empty?)

          { weekly: entries }
        else
          entries = raw_data
                    .css('.elementor-price-list-description')
                    .map do |entry|
                      entry
                        .inner_html
                        .split('<br>')
                        .map { |k| CGI.unescapeHTML(k).strip }
                    end

          { daily: entries[Time.now.wday - 1] }
        end
      end
    end
  end
end
