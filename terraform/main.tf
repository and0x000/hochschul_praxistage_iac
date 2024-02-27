terraform {
  # https://developer.hashicorp.com/terraform/language/providers/requirements
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}

# https://developer.hashicorp.com/terraform/language/values/variables
variable "hcloud_token" {
  type      = string
  sensitive = true
}

# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs
provider "hcloud" {
  token = var.hcloud_token
}

# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/ssh_key
resource "hcloud_ssh_key" "my_ssh_key" {
  name       = "my_ssh_key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server
resource "hcloud_server" "my_server" {
  name        = "my-server-1"
  image       = "docker-ce"
  location    = "nbg1"
  ssh_keys    = [ "my_ssh_key" ]
  server_type = "cx11"

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  depends_on = [
    hcloud_ssh_key.my_ssh_key
  ]
}

