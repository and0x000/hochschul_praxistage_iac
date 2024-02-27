# first things first

## install hetzner cloud collection

```
ansible-galaxy collection install -r requirements.yml
```

## credential handling

- `export HCLOUD_TOKEN=foo_bar_baz`
- `.env` file autoload (if configured for shell)
- `source .env` file (if supported by shell)
- ansible tower/AWX, hashicorp vault/OpenBao, ... (beyond the scope of this workshop)

## system setup

`ansible-playbook setup_server.yaml`

## refer to inventory

`ansible-playbook -i inventory_hcloud.yaml <task>.yaml`

## run task

`ansible-playbook -i inventory_hcloud.yaml ping.yaml`
