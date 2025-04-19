require 'prometheus_exporter/middleware'
require 'prometheus_exporter/instrumentation'

Rails.application.middleware.unshift PrometheusExporter::Middleware
PrometheusExporter::Instrumentation::Process.start(type: "web", port: 9394)