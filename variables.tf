#---------------------------------------------#
# Provider variables #
#---------------------------------------------#
variable "region" {
  description = "The AWS region to create resources in."
  default     = ""
}

variable "access_key" {
  description = "The aws access key."
  default     = ""
}

variable "secret_key" {
  description = "The aws secret key."
  default     = ""
}


variable "vpc_cidr_block" {
  description = "cidr range for vpc"
  default = ""
}

variable "public_subnet_server_a_cidr" {
  description = "subnet a cidr range"
  default = ""
}

variable "public_subnet_server_b_cidr" {
  description = "subnet b cidr range"
  default = ""
}