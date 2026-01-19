data "aws_iam_policy_document" "repository" {
  dynamic "statement" {
    for_each = length(var.trust_accounts) > 0 ? [1] : []
    content {
      sid    = "AllowPull"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = [for id in var.trust_accounts : "arn:aws:iam::${id}:root"]
      }

      actions = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
      ]
    }
  }

  statement {
    sid    = "AllowWriteMgmt"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
  }
}

resource "aws_ecr_repository_policy" "this" {
  count = var.create_repository ? 1 : 0

  repository = aws_ecr_repository.this[0].name
  policy     = data.aws_iam_policy_document.repository.json
}
