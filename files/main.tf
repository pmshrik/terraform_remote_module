resource "null_resource" "file" {
  connection {
    type        = "ssh"
    user        = var.user_name
    agent       = false
    host        = var.ec2_public_ip
    private_key = file(abspath(var.ec2_pem_path))
  }
  provisioner "file" {
    source = var.source_path
    destination = var.destination_path
}

}
