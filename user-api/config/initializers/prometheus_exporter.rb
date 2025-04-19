require 'prometheus_exporter/middleware'
require 'prometheus_exporter/server'

# This attaches rack middleware to track request metrics
Rails.application.middleware.unshift PrometheusExporter::Middleware

# Starts a standalone metrics web server 
PrometheusExporter::Server::WebServer.start bind: '0.0.0.0', port: 9394
puts "[PrometheusExporter] Exporter started on port 9394"