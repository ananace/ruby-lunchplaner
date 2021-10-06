module Lunchplaner
  module Backends
    class Zodiaken < Lunchplaner::Backend
      include Lunchplaner::Common::Hors

      url 'https://www.hors.se/linkoping/17/3/zodiaken/'
    end
  end
end
