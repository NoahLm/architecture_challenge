variable "access_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "json_route" {
  description = "route to get json file"
  type        = string
  sensitive   = true
}

variable "scripts_route" {
  description = "route to get glue script file"
  type        = string
  sensitive   = true
}

variable "redshift_master_username" {
  description = "user name for redshift cluster login"
  type        = string
  sensitive   = true
}

variable "redshift_master_password" {
  description = "password for redshift cluster login"
  type        = string
  sensitive   = true
}