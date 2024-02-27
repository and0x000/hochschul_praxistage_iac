terraform {
  # https://developer.hashicorp.com/terraform/language/providers/requirements
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "1.1.0"
    }
  }
}

# https://developer.hashicorp.com/terraform/language/values/variables
variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "node_count" {
  type    = number
  default = 3
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
  count = var.node_count

  name        = "my-server-${count.index}"
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

resource "ansible_host" "docker_nodes" {
  depends_on = [
    hcloud_server.my_server
  ]
  count  = var.node_count
  name   = hcloud_server.my_server[count.index].ipv4_address
  groups = ["docker_nodes"]
  variables = {
    ansible_user                 = "root",
    ansible_ssh_private_key_file = "~/.ssh/id_ed25519"
  }
}

