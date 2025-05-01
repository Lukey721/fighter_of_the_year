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

resource "docker_image" "prometheus" {
  name = "prom/prometheus:latest"
}

resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = docker_image.prometheus.name

  ports {
    internal = 9090
    external = 9090
  }

  volumes {
    host_path      = abspath("${var.project_root}/prometheus.yml")
    container_path = "/etc/prometheus/prometheus.yml"
  }
  
  depends_on = [module.core_infra]

  networks_advanced {
    name = module.core_infra.app_network_name
  }
}

resource "docker_image" "grafana" {
  name = "grafana/grafana:latest"
}

resource "docker_container" "grafana" {
  name  = "grafana"
  image = docker_image.grafana.name

  ports {
    internal = 3000
    external = 3000
  }

  volumes {
    host_path      = abspath("${var.project_root}/grafana")
    container_path = "/var/lib/grafana"
  }

  depends_on = [module.core_infra]

  networks_advanced {
    name = module.core_infra.app_network_name
  }
}

# User API
resource "docker_image" "user_api" {
  name = var.user_api_image
}

#resource "docker_container" "user_api" {
#  name  = "user-api"
#  image = docker_image.user_api.name
#  env = [
#    "DATABASE_URL=postgres://${var.db_user}:${var.db_password}@postgres-db:5432/${var.db_name}"
#  ]
#  ports {
#    internal = 3000
#    external = 3001
#  }
#  ports {
#    internal = 9394
#    external = 9394
#  }
#  depends_on = [module.core_infra]
#  networks_advanced {
#    name = module.core_infra.app_network_name
#  }
#}

# USER API CONTAINERS (scalable)
resource "docker_container" "user_api" {
  count = var.user_api_replicas

  name  = "user-api-${count.index}"
  image = docker_image.user_api.name

  env = [
    "DATABASE_URL=postgres://${var.db_user}:${var.db_password}@postgres-db:5432/${var.db_name}"
  ]

  ports {
    internal = 3000
    external = count.index == 1 ? 3004 : 3001 + count.index
  }

  ports {
    internal = 9394
    external = count.index == 1 ? 9397 : count.index == 2 ? 9398 : 9394 + count.index
  }

  depends_on = [module.core_infra]

  networks_advanced {
    name = module.core_infra.app_network_name
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
  ports {
    internal = 9395
    external = 9395
  }
  depends_on = [module.core_infra, docker_container.user_api]
  networks_advanced {
    name = module.core_infra.app_network_name
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
    name = module.core_infra.app_network_name
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
    name = module.core_infra.app_network_name
  }
  depends_on = [docker_container.user_api, docker_container.voting_api]
}

resource "docker_image" "frontend_main" {
  name = "frontend-main:latest"
  build {
    context = "${path.module}/../frontend-main"
  }
}

# Main front end for switching between blue and green
resource "docker_container" "frontend_main" {
  name  = "frontend-main"
  image = docker_image.frontend_main.name

  env = [
    "ACTIVE_COLOR=${var.active_color}"
  ]

  ports {
    internal = 80
    external = 8080
  }

  depends_on = [
    docker_container.frontend_blue,
    docker_container.frontend_green
  ]

  networks_advanced {
    name = module.core_infra.app_network_name
  }
}