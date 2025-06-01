variable "node_ips" {
  type        = list(string)
  description = "List of node IP addresses"
}

variable "node_roles" {
  type        = list(string)
  description = "Role for each node: master or worker"
}

variable "ssh_user" {
  type    = string
  default = "ec2-user"
}

variable "ssh_private_key_path" {
  type = string
}

variable "pod_cidr" {
  type    = string
  default = "10.244.0.0/16"
}

variable "master_ip" {
  type        = string
  description = "IP address of the Kubernetes master"
}

variable "join_token" {
  type        = string
  description = "Join token for workers"
  default     = ""
}

variable "discovery_hash" {
  type        = string
  description = "CA cert hash for joining nodes"
  default     = ""
}
