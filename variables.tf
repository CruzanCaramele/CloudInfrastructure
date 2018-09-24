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

#---------------------------------------------#
# Subnets variables #
#---------------------------------------------#
variable "vpc_cidr_block" {
  description = "cidr range for vpc"
  default     = ""
}

variable "public_subnet_server_a_cidr" {
  description = "subnet a cidr range"
  default     = ""
}

variable "public_subnet_server_b_cidr" {
  description = "subnet b cidr range"
  default     = ""
}

variable "public_subnet_bastion_a_cidr" {
  description = "bastion a cidr"
  default     = ""
}

variable "public_subnet_bastion_b_cidr" {
  description = "bastion a cidr"
  default     = ""
}

variable "private_subnet_db_a_cidr" {
  description = "database cidr subnet a"
  default     = ""
}

variable "private_subnet_db_b_cidr" {
  description = "database cidr subnet b"
  default     = ""
}
