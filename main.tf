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
      command = <<EOT
        "git clone https://github.com/twinstake/terraform-templates"
        "git checkout terra-luna"
        "chmod +x terra/testnet/bootstrap.sh"
        "terra/testnet/boostrap.sh"
      EOT
  }
}