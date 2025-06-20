resource "null_resource" "remote-exec" {
  connection {
    type        = "ssh"
    user        = var.user_name
    agent       = false
    host        = var.ec2_public_ip
    private_key = file(abspath(var.ec2_pem))
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt-get install -y ca-certificates curl",
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
      "sudo chmod a+r /etc/apt/keyrings/docker.asc",

      # ✅ This safely handles fallback *outside* any Terraform echo line
      "source /etc/os-release && CODENAME=$UBUNTU_CODENAME && [ -z \"$CODENAME\" ] && CODENAME=$VERSION_CODENAME",

      # ✅ Then use that $CODENAME directly in echo
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $CODENAME stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",

      "sudo apt-get update -y"
    ]
  }
}
