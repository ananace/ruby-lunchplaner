require 'lunchplaner/version'
require 'psych'

module Lunchplaner
  def self.all
    Backends.constants.map do |r|
      obj = Backends.const_get(r).new
      (obj.all rescue { daily: ['N/A'], weekly: ['N/A'] }).merge(source: obj, name: obj.to_s, url: obj.url)
    end
  end

  autoload :Backend, 'lunchplaner/backend'
  module Backends
    autoload :ChiliLime,           'lunchplaner/backends/chililime'
    autoload :Collegium,           'lunchplaner/backends/collegium'
    autoload :Matkultur,           'lunchplaner/backends/matkultur'
    autoload :P2g,                 'lunchplaner/backends/p2g'
    autoload :Universitetsklubben, 'lunchplaner/backends/universitetsklubben'
    autoload :Vallastaden,         'lunchplaner/backends/vallastaden'
    autoload :Zenit,               'lunchplaner/backends/zenit'
  end
end
