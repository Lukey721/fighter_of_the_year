terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}
# Database (PostgreSQL)
resource "docker_network" "app_network" {
  name = "ufc_microservices_network"
}

resource "docker_image" "postgres" {
  name = "postgres:latest"
}

resource "docker_volume" "pgdata" {
  name = "pgdata_volume"
}

resource "docker_container" "postgres_db" {
  name  = "postgres-db"
  image = docker_image.postgres.name
  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]

  ports {
    internal = 5432
    external = 5433
  }

  volumes {
    container_path = "/var/lib/postgresql/data"
    volume_name    = docker_volume.pgdata.name
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  #lifecycle {
  #  prevent_destroy = true
  #}
}