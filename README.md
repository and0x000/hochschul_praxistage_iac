# boilerplate IaC code

This repo contains boilerplate and starting points for a tour through infrastructure as code.

## quick references

### terraform

[Doku](https://developer.hashicorp.com/terraform/docs)

#### declaration language basic

##### providers
```hcl
provider "hcloud" {
  token = var.hcloud_token
}
```

##### resources

```hcl
resource "hcloud_server" "super_duper_server" {
  name = "super-duper-server-1"
  ...
}
```

##### variables

```hcl
variable "image-name" {
  type    = string
  default = "debian-12"
}
```

##### outputs

```hcl

output "instance_ip" {
  value = hcloud_server.super_duper_server.public_ip
}
```

#### command line usage

- `terraform init`
- `terraform plan`
- `terraform apply`
- `terraform destroy`

### ansible

#### inventory


```yaml
---
# inventory.yaml
web:
  hosts:
    super-duper-server-1.hetzner.com:
```

- [How to build your inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)

#### playbook

```yaml
---
# install_nginx.yaml
- name: Install and Configure Nginx
  hosts: web
  tasks:
    - name: Install Nginx
      ansible.builtin.apt:
        name: nginx
        state: present
    - name: Ensure Nginx is running
      ansible.builtin.service:
        name: nginx
        state: started
```
- [Ansible playbooks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html)
- [ansible.builtin.apt](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html)
- [ansible.builtin.service](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html)

#### variables & templates


```yaml
---
- name: Use Variables
  hosts: web
  vars:
    nginx_port: 80
  tasks:
    - name: Install Nginx
      ansible.builtin.apt:
        name: nginx
        state: present
    - name: Configure Nginx
      ansible.builtin.template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
```

- [ansible.builtin.template](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)

#### loops & conditionals

```yaml
---
- name: Use Loops and Conditionals
  hosts: web
  tasks:
    - name: Create Users
      ansible.builtin.user:
        name: "{{ item }}"
        state: present
      loop:
        - user1
        - user2
      when: ansible_os_family == "Debian"
```

- [ansible.builtin.user](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html)
- [Loops](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html)
- [Conditionals](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html)

#### handlers

```yaml
---
- name: Restart Nginx if Config Changed
  hosts: web
  tasks:
    - name: Update Nginx Config
      ansible.builtin.template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
      notify:
        - restart nginx

handlers:
  - name: restart nginx
    ansible.builtin.service:
      name: nginx
      state: restarted
```

- [Handlers: running operations on change](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_handlers.html)

#### command line usage

- `ansible-playbook -i inventory.yaml install_nginx.yml`
- `ansible-galaxy collection install hetzner.hcloud`
