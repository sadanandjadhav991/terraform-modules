variable "host" {
  description = "IP address of the RHEL host"
  type        = string
}

variable "ssh_user" {
  description = "SSH username"
  type        = string
  default     = "ec2-user"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key"
  type        = string
}

variable "node_type" {
  description = "Type of the node: master or worker"
  type        = string
  default     = "master"
}
