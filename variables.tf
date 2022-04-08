variable "linode_token" {
  description = "Token used for Linode API access"
}

variable "ubuntu_root_pass" {
  description = "Root password for Linode instance"
}

variable "nick_macbook_public_key" {
  description = "Nick's MacBook Air public key"
}

variable "linode_node_type" {
  description = "Linode node type / plan"
}

variable "linode_node_region" {
  description = "Region where node will be spwaned"
}

variable "linode_node_image" {
  description = "Image used to spwan node"
}

variable "linode_tags" {
  description = "Tags for node"
}

variable "linode_group" {
  description = "Group that node will be a part of"
}