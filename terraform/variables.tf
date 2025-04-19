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
  description = "Absolute path to the project root "
  default     = "C:/Users/lukey/OneDrive - Technological University Dublin/Code/College Projects/ufc-voting-microservices"
}