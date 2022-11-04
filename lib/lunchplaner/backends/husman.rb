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
        data.css('.jet-listing .e-con-full .e-con-boxed > .e-con-inner > .e-con-boxed span.elementor-heading-title').reject { |e| e.content =~ /V.lkommen!/ }.map do |e|
          e.content.strip.delete "\n"
        end
      end
    end
  end
end
