require "lunchplaner/version"
require 'psych'

module Lunchplaner
  def self.today
    Backends.constants.map do |r|
      obj = Backends.const_get(r).new
      { obj => obj.all }
    end
  end

  autoload :Backend, 'lunchplaner/backend'
  module Backends
    autoload :Chililime,           'lunchplaner/backends/chililime'
    autoload :Universitetsklubben, 'lunchplaner/backends/universitetsklubben'
    autoload :Zenit,               'lunchplaner/backends/zenit'
  end
end
