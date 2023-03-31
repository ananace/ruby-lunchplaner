# frozen_string_literal: true

require 'lunchplaner'

require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter

map '/' do
  run Lunchplaner::API
end
