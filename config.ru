# frozen_string_literal: true

require 'lunchplaner'

map '/' do
  run Lunchplaner::API
end
