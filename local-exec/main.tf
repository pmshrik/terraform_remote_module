resource "null_resource" "local-exec" {
    provisioner "local-exec" {
        command = var.command_local
    }
}