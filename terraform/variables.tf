variable "db_user" {
  type    = string
  default = "postgres"
}

variable "db_password" {
  type    = string
  default = "password"
}

variable "db_name" {
  type    = string
  default = "user_api_development"
}

variable "user_api_image" {
  type = string
}

variable "user_api_replicas" {
  type        = number
  default     = 1
  description = "Number of user-api replicas to deploy - used for time scaling"
}

variable "voting_api_image" {
  type = string
}

variable "frontend_blue_image" {
  type = string
}
variable "frontend_green_image" {
  type = string
}

variable "project_root" {
  type        = string
  description = "Path to the root directory of the project"
  default     = ".."
}

variable "active_color" {
  type    = string
  default = "blue"
}