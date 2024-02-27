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
