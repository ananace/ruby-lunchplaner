require 'lunchplaner/version'
require 'psych'
require 'time'

module Lunchplaner
  def self.all
    Backends.constants.map do |r|
      obj = Backends.const_get(r).new
      (obj.all rescue { daily: ['N/A'], weekly: ['N/A'] }).merge(source: obj, name: obj.to_s, url: obj.url, links: obj.links)
    end
  end

  autoload :Backend, 'lunchplaner/backend'
  module Backends
    autoload :BrodernasKok,        'lunchplaner/backends/brodernaskok'
    autoload :ChiliLime,           'lunchplaner/backends/chililime'
    # autoload :FreshMarket,         'lunchplaner/backends/fresh_market'
    autoload :Husman,              'lunchplaner/backends/husman'
    autoload :P2g,                 'lunchplaner/backends/p2g'

    if Time.now > Time.parse('2021-10-04')
      autoload :Universitetsklubben, 'lunchplaner/backends/universitetsklubben' # Opens on 4/10
    end
  end
end
