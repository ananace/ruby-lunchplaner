# frozen_string_literal: true

require 'lunchplaner/version'
require 'lunchplaner/api'

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
    autoload :Bores,               'lunchplaner/backends/bores'
    autoload :BrodernasKok,        'lunchplaner/backends/brodernaskok'
    autoload :ChiliLime,           'lunchplaner/backends/chililime'
    autoload :Falafelhuset,        'lunchplaner/backends/falafelhuset'
    autoload :FreshMarket,         'lunchplaner/backends/fresh_market'
    autoload :Husman,              'lunchplaner/backends/husman'
    autoload :Karallen,            'lunchplaner/backends/karallen'
    autoload :LaFontana,           'lunchplaner/backends/la_fontana'
    # autoload :P2g,                 'lunchplaner/backends/p2g'
    autoload :SpicyWokNRoll,       'lunchplaner/backends/spicy_wok_n_roll'
    autoload :Stangs,              'lunchplaner/backends/stangs'
    autoload :Universitetsklubben, 'lunchplaner/backends/universitetsklubben'
    autoload :Zodiaken,            'lunchplaner/backends/zodiaken'
  end

  module Common
    autoload :Hors, 'lunchplaner/common/hors'
  end
end
