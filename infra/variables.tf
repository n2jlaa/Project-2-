# -------------------------------
# Project-wide variables
# -------------------------------
variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "devopsproj2najla"
}

variable "rg_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-najla-devopsproj2"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "japaneast"
}

variable "sql_admin_user" {
  description = "SQL server admin username"
  type        = string
  default     = "sqladminuser"
}

variable "sql_admin_password" {
  description = "SQL server admin password"
  type        = string
  sensitive   = true
  default     = "Ironhack-sda7"
}