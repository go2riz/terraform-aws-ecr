terraform {
  moved {
    from = aws_ecr_repository.default
    to   = aws_ecr_repository.this[0]
  }

  moved {
    from = aws_ecr_lifecycle_policy.default
    to   = aws_ecr_lifecycle_policy.this[0]
  }

  moved {
    from = aws_ecr_repository_policy.default
    to   = aws_ecr_repository_policy.this[0]
  }
}
