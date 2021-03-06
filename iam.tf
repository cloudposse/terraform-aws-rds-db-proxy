# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.html

locals {
  iam_role_enabled = var.existing_iam_role_arn == mull || var.existing_iam_role_arn == "" ? true : false
  asm_secret_arns  = compact([for auth in var.auth : lookup(auth, "secret_arn", "")])
}

data "aws_iam_policy_document" "assume_role" {
  count = local.iam_role_enabled ? 1 : 0

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
  count = local.iam_role_enabled ? 1 : 0

  statement {
    sid = "AllowRdsToGetSecretValueFromSecretsManager"

    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = local.asm_secret_arns
  }
}

module "role_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  enabled    = local.iam_role_enabled
  attributes = var.iam_role_attributes
  context    = module.this.context
}

resource "aws_iam_policy" "this" {
  count  = local.iam_role_enabled ? 1 : 0
  name   = module.role_label.id
  policy = join("", data.aws_iam_policy_document.this.*.json)
}

resource "aws_iam_role" "this" {
  count              = local.iam_role_enabled ? 1 : 0
  name               = module.role_label.id
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
  tags               = module.role_label.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = local.iam_role_enabled ? 1 : 0
  policy_arn = join("", aws_iam_policy.this.*.arn)
  role       = aws_iam_role.this.name
}
