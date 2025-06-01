provider "ssh" {
  host     = var.host
  user     = var.ssh_user
  private_key = file(var.ssh_private_key_path)
}

resource "null_resource" "k8s_install" {
  connection {
    type        = "ssh"
    host        = var.host
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/install_k8s.sh"
    destination = "/tmp/install_k8s.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_k8s.sh",
      "sudo /tmp/install_k8s.sh ${var.node_type}"
    ]
  }
}
