# frozen_string_literal: true

require 'lunchplaner'

require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter

map '/healthz' do
  run ->(_env) { ['200', { 'Content-Type' => 'text/plain' }, ['OK']] }
end

map '/' do
  run Lunchplaner::API
end
