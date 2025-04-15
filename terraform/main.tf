terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "ufc_microservices_network"
}

# Database (PostgreSQL)
resource "docker_image" "postgres" {
  name = "postgres:latest"
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
  host_path      = "${abspath(path.module)}/db_data"
  }
  networks_advanced {
    name = docker_network.app_network.name
  }
}

# User API
resource "docker_image" "user_api" {
  name = var.user_api_image
}

resource "docker_container" "user_api" {
  name  = "user-api"
  image = docker_image.user_api.name
  env = [
    "DATABASE_URL=postgres://${var.db_user}:${var.db_password}@postgres-db:5432/${var.db_name}"
  ]
  ports {
    internal = 3000
    external = 3001
  }
  depends_on = [docker_container.postgres_db]
  networks_advanced {
    name = docker_network.app_network.name
  }
}

# Voting API
resource "docker_image" "voting_api" {
  name = var.voting_api_image
}

resource "docker_container" "voting_api" {
  name  = "voting-api"
  image = docker_image.voting_api.name
  env = [
    "DATABASE_URL=postgres://${var.db_user}:${var.db_password}@postgres-db:5432/${var.db_name}",
    "USER_API_URL=http://user-api:3000"
  ]
  ports {
    internal = 3000
    external = 3002
  }
  depends_on = [docker_container.postgres_db, docker_container.user_api]
  networks_advanced {
    name = docker_network.app_network.name
  }
}

# Frontend - BLUE
resource "docker_image" "frontend_blue" {
  name = var.frontend_blue_image
}
resource "docker_image" "frontend_green" {
  name = var.frontend_green_image
}

resource "docker_container" "frontend_blue" {
  name  = "frontend-blue"
  image = docker_image.frontend_blue.name
  env = [
    "USER_API_URL=http://user-api:3000",
    "VOTING_API_URL=http://voting-api:3000"
  ]
  ports {
    internal = 3000
    external = 3005
  }
  networks_advanced {
    name = docker_network.app_network.name
  }
  depends_on = [docker_container.user_api, docker_container.voting_api]
}

# Frontend - GREEN
resource "docker_container" "frontend_green" {
  name  = "frontend-green"
  image = docker_image.frontend_green.name
  env = [
    "USER_API_URL=http://user-api:3000",
    "VOTING_API_URL=http://voting-api:3000"
  ]
  ports {
    internal = 3000
    external = 3006
  }
  networks_advanced {
    name = docker_network.app_network.name
  }
  depends_on = [docker_container.user_api, docker_container.voting_api]
}