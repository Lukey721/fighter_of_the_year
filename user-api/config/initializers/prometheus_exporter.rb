# frozen_string_literal: true

require 'prometheus_exporter/middleware'
require 'prometheus_exporter/server'

Rails.application.middleware.unshift PrometheusExporter::Middleware

# ✅ CORRECT usage of exporter server
server = PrometheusExporter::Server::WebServer.new bind: '0.0.0.0', port: 9394
server.start
