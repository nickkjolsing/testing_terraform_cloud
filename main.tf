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
  
  connection {
    type = "ssh"
    user = "root"
    password = var.ubuntu_root_pass
    host = self.ip_address
  }


  provisioner "remote-exec" {
      inline = [
        "curl https://raw.githubusercontent.com/nickkjolsing/testing_terraform_cloud/main/bootstrap.sh > bootstrap.sh",
        "curl https://raw.githubusercontent.com/nickkjolsing/testing_terraform_cloud/main/terrad.service > terrad.service",
        "chmod +x bootstrap.sh",
        "./bootstrap.sh"
      ]
  }
}