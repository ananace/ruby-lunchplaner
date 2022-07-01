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
    autoload :Bores,               'lunchplaner/backends/bores' if Time.now > Time.parse('2022-07-24')
    autoload :BrodernasKok,        'lunchplaner/backends/brodernaskok'
    autoload :ChiliLime,           'lunchplaner/backends/chililime'
    autoload :Falafelhuset,        'lunchplaner/backends/falafelhuset' # Konkurs 2022-06-02
    autoload :FreshMarket,         'lunchplaner/backends/fresh_market' if Time.now > Time.parse('2022-08-15')
    autoload :Husman,              'lunchplaner/backends/husman'
    autoload :Karallen,            'lunchplaner/backends/karallen' if Time.now > Time.parse('2022-08-15')
    autoload :LaFontana,           'lunchplaner/backends/la_fontana'
    # autoload :P2g,                 'lunchplaner/backends/p2g'
    autoload :SpicyWokNRoll,       'lunchplaner/backends/spicy_wok_n_roll'
    autoload :Stangs,              'lunchplaner/backends/stangs'
    autoload :Universitetsklubben, 'lunchplaner/backends/universitetsklubben' if Time.parse('2022-06-23 23:59') >= Time.now || Time.now >= Time.parse('2022-08-15 00:00')
    autoload :Zodiaken,            'lunchplaner/backends/zodiaken' if Time.parse('2022-06-23 23:59') >= Time.now || Time.now >= Time.parse('2022-08-15 00:00')
  end

  module Common
    autoload :Hors, 'lunchplaner/common/hors'
  end
end
