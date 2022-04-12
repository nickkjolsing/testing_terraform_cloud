# provider "linode" {
#   token = var.linode_token
# }

# resource "linode_instance" "web" {
#   label           = "dev-terra-luna-usne-0"
#   image           = var.linode_node_image
#   region          = var.linode_node_region
#   type            = var.linode_node_type
#   authorized_keys = var.nick_macbook_public_key
#   root_pass       = var.ubuntu_root_pass

#   group = var.linode_group
#   tags  = var.linode_tags

#   private_ip = true
# }

provider "hcloud" {
  token = var.hetzner_token
}

resource "hcloud_server" "terra_1" {
  name        = "terra_1"
  image       = "ubuntu-20.04"
  server_type = "cx11"
  location    = "ash"
  ssh_keys    = var.nick_macbook_public_key
}