require 'prometheus_exporter/middleware'

# Attach middleware for automatic request metrics
Rails.application.middleware.unshift PrometheusExporter::Middleware

puts "[PrometheusExporter] Middleware initialized"