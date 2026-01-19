# These resources manage registry/account-level settings.
# They are SINGLETON per AWS account + region.
# Enable them in ONLY ONE module instance (manage_registry_scan_settings = true)

resource "aws_ecr_account_setting" "basic_scan_type_version" {
  count = var.manage_registry_scan_settings ? 1 : 0

  name  = "BASIC_SCAN_TYPE_VERSION"
  value = var.basic_scan_type_version
}

resource "aws_ecr_registry_scanning_configuration" "this" {
  count = var.manage_registry_scan_settings ? 1 : 0

  scan_type = var.registry_scan_type

  dynamic "rule" {
    for_each = var.registry_scan_rules
    content {
      scan_frequency = rule.value.scan_frequency

      repository_filter {
        filter      = rule.value.filter
        filter_type = rule.value.filter_type
      }
    }
  }
}
