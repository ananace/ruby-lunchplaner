# frozen_string_literal: true

module Lunchplaner
  module Backends
    class Universitetsklubben < Lunchplaner::Backend
      include Lunchplaner::Common::Hors

      url 'https://www.hors.se/linkoping/17/6/universitetsklubben/'
    end
  end
end
