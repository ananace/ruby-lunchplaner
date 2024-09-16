# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Studenthuset < Lunchplaner::Backend
      include Lunchplaner::Common::Hors

      url 'https://www.hors.se/linkoping/17/8/restaurang-studenthuset/'
    end
  end
end
