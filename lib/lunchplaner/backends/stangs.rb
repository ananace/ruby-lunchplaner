# frozen_string_literal: true

require 'net/http'

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

      PRODUCT_LIST = %w[
        724424a0-f7f8-4ecf-9569-9f828163ff66

        4323000c-6aa1-4724-8dfe-231be5521a2e
        5d09056e-97ee-449d-9efa-36dbc648b26c
        9b12f63e-1d18-408e-8225-137957ab2391
      ].freeze
      # Chokladmousse - also in mealoftheweeks
      #  0bfae91e-be52-4db8-b098-24248a728af7

      private

      def raw_data
        # rubocop:disable Metrics/BlockLength
        Backend.cache.get_or_set("raw_data-#{self.class.name}", expires_in: 1 * 60 * 60) do
          puts "Refreshing cache for #{self.class.name}..."

          q = {
            system: 'stangs-mjardevi',
            table: 'mealofthedays',
            condition: {
              workday: {
                '$lte': Time.now.strftime('%Y-%m-%d'), '$gte': Time.now.strftime('%Y-%m-%d')
              }
            }
          }

          u = URI('https://db20.bokad.se/find')
          data = Net::HTTP.post(u, q.to_json, { 'Content-Type' => 'application/json' })
          daily = JSON.parse(data.body, symbolize_names: true)

          q[:table] = 'products'
          q[:condition] = {
            id: {
              '$in': PRODUCT_LIST
            }
          }

          data = Net::HTTP.post(u, q.to_json, { 'Content-Type' => 'application/json' })
          select = JSON.parse(data.body, symbolize_names: true)

          q[:table] = 'mealoftheweeks'
          q[:condition] = {
            year: Time.now.year,
            weekNumber: Time.now.strftime('%-V').to_i
          }

          data = Net::HTTP.post(u, q.to_json, { 'Content-Type' => 'application/json' })
          weekly = JSON.parse(data.body, symbolize_names: true)

          {
            daily: daily,
            weekly: select + weekly
          }
        end
        # rubocop:enable Metrics/BlockLength
      end

      def data
        map_entry = proc do |entry|
          name = entry[:name]
          "#{name[0]}#{name[1..].downcase.strip} - #{entry[:description].strip}"
        end

        data = raw_data[:daily].dup
        data.delete_if { |d| d[:name].match?(/(avh|ta):/i) }
        data.each do |d|
          d[:name].sub!(/dagens ?(rätt|grön[at])?:?/i, '')
          d[:name].strip!
        end

        name = data.first&.[](:name)
        if name
          daily = map_entry.call(data.first)
          data.delete_if { |d| d[:name].downcase.include?(name.downcase) }
        end

        name = data.first&.[](:name)
        if name
          daily_veg = map_entry.call(data.first)
          data.delete_if { |d| d[:name].downcase.include?(name.downcase) }
        end

        weekly = []
        loop do
          break if data.empty?
          break unless data.first&.[](:name)&.start_with?('VECKANS')

          name = data.first[:name]
          parsed = map_entry.call(data.first)
          weekly << parsed
          data.delete_if { |d| d[:name].downcase.start_with?(name.downcase) }
        end

        data = raw_data[:weekly]
        data.delete_if { |d| d[:name].match?(/(avh|ta):/i) }

        weekly += data.reject { |d| d[:description].empty? }.map(&map_entry)

        { daily: [daily, daily_veg].compact, weekly: weekly }
      end
    end
  end
end
