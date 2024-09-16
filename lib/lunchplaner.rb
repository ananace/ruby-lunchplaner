# frozen_string_literal: true

require 'lunchplaner/version'
require 'lunchplaner/api'

require 'psych'
require 'time'

module Lunchplaner
  def self.all
    Backends.constants.map do |r|
      obj = Backends.const_get(r).new
      # next unless obj.open?

      (obj.all rescue { daily: ['N/A'], weekly: ['N/A'], open: false }).merge(source: obj, name: obj.to_s, url: obj.url, links: obj.links)
    end.compact
  end

  autoload :Backend, 'lunchplaner/backend'
  module Backends
    autoload :Bestia,              'lunchplaner/backends/bestia'
    # Main company bankrupt at 2024-01-29, university location still open
    autoload :Bores,               'lunchplaner/backends/bores'
    autoload :BrodernasKok,        'lunchplaner/backends/brodernaskok'
    autoload :ChiliLime,           'lunchplaner/backends/chililime'
    autoload :DolceVita,           'lunchplaner/backends/dolce_vita'
    # Main company bankrupt at 2022-06-02, university location still open
    autoload :Falafelhuset,        'lunchplaner/backends/falafelhuset'
    autoload :Husman,              'lunchplaner/backends/husman'
    autoload :Karallen,            'lunchplaner/backends/karallen'
    autoload :LaFontana,           'lunchplaner/backends/la_fontana'
    autoload :PegsAndTails,        'lunchplaner/backends/pegs_and_tails'
    autoload :SpicyWokNRoll,       'lunchplaner/backends/spicy_wok_n_roll'
    autoload :Studenthuset,        'lunchplaner/backends/studenthuset'
    autoload :Stangs,              'lunchplaner/backends/stangs'
    autoload :TomiSushi,           'lunchplaner/backends/tomi_sushi'
    autoload :Universitetsklubben, 'lunchplaner/backends/universitetsklubben'
    autoload :VallastadensPizza,   'lunchplaner/backends/vallastadens_pizza'
  end

  module Common
    autoload :Hors, 'lunchplaner/common/hors'
  end
end
