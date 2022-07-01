# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Stangs < Lunchplaner::Backend
      url 'https://stangsmjardevi.se'

      def open?
        Time.parse('2022-07-09') > Time.now || Time.now > Time.parse('2022-08-08')
      end

      def daily
        data[:daily]
      end

      def weekly
        data[:weekly]
      end

      def to_s
        'Stångs Mjärdevi'
      end

      private

      def raw_data
        Backend.cache.get_or_set("raw_data-#{self.class.name}", expires_in: 1 * 60 * 60) do
          puts "Refreshing cache for #{self.class.name}..."
          JSON.parse(URI('https://stangsmjardevi.se/wp-json/wp/v2/pages?slug=hem').open(read_timeout: 15).read, symbolize_names: true)
        end
      end

      def data
        menu = raw_data.first.dig(:fields, :sections).find { |m| m[:acf_fc_layout] == 'menu_alt' && m[:title].downcase.start_with?('lunch') }

        daily = Nokogiri::HTML(menu[:main_column])
                        .css('h3 + p')
                        .reject { |b| b[:class] == 'price' }
                        .map { |b| b.text.gsub("\n", ' - ') }
                        .select { |t| t.include? '-' }[Time.now.wday - 1]
        daily_veg = Nokogiri::HTML(menu[:main_column])
                            .css('h4 + p')
                            .reject { |b| b[:class] == 'price' }
                            .map { |b| b.text.gsub("\n", ' - ') }
                            .select { |t| t.include? '-' }[Time.now.wday - 1]

        weekly = Nokogiri::HTML(menu[:side_column])
                         .css('p')
                         .reject { |b| b[:class] == 'price' }
                         .map { |b| b.text.gsub("\n", ' - ') }
                         .select { |t| t.include? '-' }

        { daily: [daily, daily_veg], weekly: weekly }
      end
    end
  end
end
