resource "null_resource" "remote-exec" {
    connection {
      type = "ssh"
      user = var.user_name
      agent = false
      host = var.ec2_public_ip
      private_key = file(var.ec2_pem)
    }

    provisioner "remote-exec" {
        inline = [ 
            "sudo apt update -y",
            "sudo apt-get install ca-certificates curl",
            "sudo install -m 0755 -d /etc/apt/keyrings",
            "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
            "sudo chmod a+r /etc/apt/keyrings/docker.asc",
            "echo \"deb [arch=\\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \\$(. /etc/os-release && echo \\${UBUNTU_CODENAME}:-\\${VERSION_CODENAME}) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
            "sudo apt-get update -y"
        ]
    }
}