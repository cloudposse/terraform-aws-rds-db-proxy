# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.html

locals {
  asm_secret_arns = compact([for auth in var.auth : lookup(auth, "secret_arn", "")])
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    sid = "AllowRdsToGetSecretValueFromAmazonSecretManager"

    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = local.asm_secret_arns
  }
}

module "role_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  attributes = var.iam_role_attributes
  context    = module.this.context
}

resource "aws_iam_policy" "this" {
  name   = module.role_label.id
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role" "this" {
  name               = module.role_label.id
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = module.this.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}
