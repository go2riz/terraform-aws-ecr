output "repository_name" {
  description = "ECR repository name"
  value       = try(aws_ecr_repository.this[0].name, null)
}

output "repository_arn" {
  description = "ECR repository ARN"
  value       = try(aws_ecr_repository.this[0].arn, null)
}

output "repository_url" {
  description = "ECR repository URL"
  value       = try(aws_ecr_repository.this[0].repository_url, null)
}

output "basic_scan_type_version" {
  description = "The configured ECR BASIC_SCAN_TYPE_VERSION when manage_registry_scan_settings=true, else null."
  value       = try(aws_ecr_account_setting.basic_scan_type_version[0].value, null)
}

output "registry_scan_type" {
  description = "The configured registry scan_type when manage_registry_scan_settings=true, else null."
  value       = try(aws_ecr_registry_scanning_configuration.this[0].scan_type, null)
}
