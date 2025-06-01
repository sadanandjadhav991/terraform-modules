output "kubeconfig" {
  value = file("/etc/kubernetes/admin.conf")
  sensitive = true
}
