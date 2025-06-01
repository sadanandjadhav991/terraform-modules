resource "null_resource" "k8s_node" {
  count = length(var.node_ips)

  connection {
    type        = "ssh"
    host        = var.node_ips[count.index]
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "file" {
  source      = "${path.module}/scripts/install_k8s_prereqs.sh"
  destination = "/tmp/install_k8s_prereqs.sh"
}

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_k8s_prereqs.sh",
        "sudo /tmp/install_k8s_prereqs.sh"
  ]
}

  provisioner "file" {
    source      = "${path.module}/scripts/cni_flannel.sh"
    destination = "/tmp/cni_flannel.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/cni_flannel.sh",
      "sudo /tmp/cni_flannel.sh ${var.pod_cidr}"
    ]
  }

  provisioner "file" {
    source      = "${path.module}/scripts/"
    destination = "/tmp/"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/*.sh",
      var.node_roles[count.index] == "master" ?
        "sudo /tmp/install_k8s_master.sh" :
        "sudo /tmp/install_k8s_worker.sh"
    ]
  }
}
