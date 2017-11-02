require "lunchplaner/version"
require 'psych'

module Lunchplaner
  def self.today
    Backends.constants.map do |r|
      obj = Backends.const_get(r).new
      { obj => (obj.all rescue { daily: ['N/A'], weekly: ['N/A'] }) }
    end
  end

  autoload :Backend, 'lunchplaner/backend'
  module Backends
    autoload :Chililime,           'lunchplaner/backends/chililime'
    autoload :Collegium,           'lunchplaner/backends/collegium'
    autoload :Universitetsklubben, 'lunchplaner/backends/universitetsklubben'
    autoload :Matkultur,           'lunchplaner/backends/matkultur'
    autoload :Vallastaden,         'lunchplaner/backends/vallastaden'
    autoload :Zenit,               'lunchplaner/backends/zenit'
  end
end
