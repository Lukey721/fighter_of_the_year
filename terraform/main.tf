terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}
provider "docker" {}

module "core_infra" {
  source      = "./modules/core_infra"
  db_user     = var.db_user
  db_password = var.db_password
  db_name     = var.db_name
}

resource "docker_image" "k6" {
  name = "grafana/k6"
}

resource "docker_container" "k6_test_runner" {
  name  = "k6-loadtest"
  image = docker_image.k6.name

  entrypoint = ["/bin/sh", "/tests/k6-entrypoint.sh"]

  volumes {
  host_path      = abspath("${path.module}/${var.k6_test_path}")
  container_path = "/tests"
 }
  networks_advanced {
    name = module.core_infra.app_network_name
  }
}
resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}