output "postgres_container_name" {
  value = docker_container.postgres_db.name
}

output "app_network_name" {
  value = docker_network.app_network.name
}
