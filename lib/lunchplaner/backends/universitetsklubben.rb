module Lunchplaner
  module Backends
    class Universitetsklubben < Lunchplaner::Backend
      url 'https://www.hors.se/linkoping/17/6/universitetsklubben/'

      def daily
        items = data.css('#current .menu-container .menu-col .menu-item')
        day = Time.now.wday - 1

        return [] if day.negative? || day > 4

        items[day]
          .content
          .strip
          .split("\n")
          .reject { |c| c =~ DAY_REX }
          .reject { |c| c.length < 5 }
      end
    end
  end
end
