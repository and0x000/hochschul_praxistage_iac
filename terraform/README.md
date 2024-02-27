# first things first

## install hetzner cloud collection

```
terraform init
```

## credential handling

`terraform.tfvars` file

## running terraform

- `terraform plan`
- `terraform apply`

## ansible inventory from terraform.tfstate

`ansible-inventory -i inventory.yaml --graph --vars`

## run ansible task

`ansible-playbook -i inventory.yaml ping.yaml`
