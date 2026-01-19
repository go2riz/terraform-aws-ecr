# terraform-aws-ecr

Ye module **ECR repository** create karta hai (policy + optional registry scanning settings).

## Clair deprecation (Feb 2, 2026)
ECR basic scanning ka **engine** (AWS_NATIVE vs CLAIR) repository ke andar nahi hota, balkay **account/registry (per AWS account + region)** level par set hota hai.

- Repository ka `scan_on_push` sirf scan trigger karta hai.
- Engine select karna: `BASIC_SCAN_TYPE_VERSION = AWS_NATIVE|CLAIR`
- Clair deprecated hai aur **Feb 2, 2026** ke baad support nahi rahega.

Is module me optional support add ki gayi hai taake aap Terraform se **AWS_NATIVE** enforce kar sako.

## Usage

### 1) Normal repository (per repo)
```hcl
module "ecr_repo" {
  source = "./terraform-aws-ecr"

  name           = "my-app"
  trust_accounts = ["123456789012", "234567890123"]

  tags = {
    Environment = "mgmt"
    Service     = "my-app"
  }
}
```

### 2) Registry scanning settings (SINGLETON) — sirf 1 dafa
> IMPORTANT: Ye settings **singleton** hoti hain. Inko **sirf ek** module instance me enable karein,
warna Terraform duplicate resource error dega.

```hcl
module "ecr_registry_settings" {
  source = "./terraform-aws-ecr"

  # Sirf registry/account settings manage karni hain, repo nahi.
  create_repository = false

  manage_registry_scan_settings = true
  basic_scan_type_version       = "AWS_NATIVE"

  # BASIC ya ENHANCED
  registry_scan_type = "BASIC"

  # Default: SCAN_ON_PUSH for all repos
  registry_scan_rules = [
    {
      scan_frequency = "SCAN_ON_PUSH"
      filter         = "*"
      filter_type    = "WILDCARD"
    }
  ]
}
```

## Variables (high level)
- `repository_scan_on_push` (default true)
- `manage_registry_scan_settings` (default false)
- `basic_scan_type_version` (default AWS_NATIVE)
- `registry_scan_type` (default BASIC)
- `registry_scan_rules` (default: scan all repos on push)

## Notes
- AWS provider `>= 5.81.0` required (because `aws_ecr_account_setting`).
