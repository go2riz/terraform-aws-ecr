variable "name" {
  description = "Name for the ECR repository (required when create_repository = true)"
  type        = string
  nullable    = true
  default     = null

  validation {
    condition     = var.create_repository ? (var.name != null && var.name != "") : true
    error_message = "name is required when create_repository = true."
  }
}

variable "trust_accounts" {
  description = "AWS account IDs that are allowed to pull images from this repository"
  type        = list(string)
  default     = []
}

variable "create_repository" {
  description = "When true, create the ECR repository + policy. Set to false if you only want to manage registry scanning settings."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to ECR resources"
  type        = map(string)
  default     = {}
}

variable "image_tag_mutability" {
  description = "Image tag mutability for the repository. Valid values: MUTABLE or IMMUTABLE."
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be one of: MUTABLE, IMMUTABLE."
  }
}

variable "repository_scan_on_push" {
  description = "Enable repository-level scan on push. (Note: the scanning engine is controlled by the registry account setting BASIC_SCAN_TYPE_VERSION.)"
  type        = bool
  default     = true
}

# --- Registry/account-level scanning controls (apply ONCE per account/region) ---

variable "manage_registry_scan_settings" {
  description = "When true, this module will manage ECR registry/account scanning settings (singleton per account/region). Enable this in ONLY ONE module instance."
  type        = bool
  default     = false
}

variable "basic_scan_type_version" {
  description = "ECR basic scanning engine selection. Valid values: AWS_NATIVE or CLAIR. (CLAIR is deprecated and will be unsupported after Feb 2, 2026.)"
  type        = string
  default     = "AWS_NATIVE"

  validation {
    condition     = contains(["AWS_NATIVE", "CLAIR"], var.basic_scan_type_version)
    error_message = "basic_scan_type_version must be one of: AWS_NATIVE, CLAIR."
  }
}

variable "registry_scan_type" {
  description = "Registry scanning type. Valid values: BASIC or ENHANCED."
  type        = string
  default     = "BASIC"

  validation {
    condition     = contains(["BASIC", "ENHANCED"], var.registry_scan_type)
    error_message = "registry_scan_type must be one of: BASIC, ENHANCED."
  }
}

variable "registry_scan_rules" {
  description = <<EOT
List of registry scan rules. Only used when manage_registry_scan_settings = true.
Each rule:
- scan_frequency: SCAN_ON_PUSH | MANUAL | CONTINUOUS_SCAN
- filter: repository filter value
- filter_type: WILDCARD
EOT

  type = list(object({
    scan_frequency = string
    filter         = string
    filter_type    = string
  }))

  default = [
    {
      scan_frequency = "SCAN_ON_PUSH"
      filter         = "*"
      filter_type    = "WILDCARD"
    }
  ]
}
