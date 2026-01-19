resource "aws_ecr_repository" "this" {
  count = var.create_repository ? 1 : 0

  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.repository_scan_on_push
  }

  tags = var.tags
}
