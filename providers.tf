terraform {
  cloud {
    organization = "twinstake"

    workspaces {
      name = "linode-terra-testnet"
    }
  }

  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}