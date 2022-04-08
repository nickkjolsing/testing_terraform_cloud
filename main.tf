provider "linode" {
  token = var.linode_token
}

resource "linode_instance" "web" {
  label           = "dev-terra-luna-usne-0"
  image           = var.linode_node_image
  region          = var.linode_node_region
  type            = var.linode_node_type
  authorized_keys = var.nick_macbook_public_key
  root_pass       = var.ubuntu_root_pass

  group = var.linode_group
  tags  = var.linode_tags

  private_ip = true

  provisioner "local-exec" {
      interpreter = ["/bin/bash", "-c"]
      command = <<EOT
        exec "git clone https://github.com/nickkjolsing/testing_terraform_cloud"
        exec "chmod +x testing_terraform_cloud/bootstrap.sh"
        exec "testing_terraform_cloud/bootstrap.sh"
      EOT
  }
}