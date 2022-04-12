# terraform {
#   cloud {
#     organization = "twinstake"

#     workspaces {
#       name = "terra-testnet-linode"
#     }
#   }

#   required_providers {
#     linode = {
#       source = "linode/linode"
#     }
#   }
# }

hcloud {
  cloud {
    organization = "twinstake"

    workspaces {
      name = "terra-testnet-linode"
    }
  }

  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}