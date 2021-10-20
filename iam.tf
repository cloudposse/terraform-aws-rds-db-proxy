# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.html

locals {
  iam_role_enabled = var.existing_iam_role_arn == null || var.existing_iam_role_arn == "" ? true : false
  asm_secret_arns  = compact([for auth in var.auth : lookup(auth, "secret_arn", "")])
  kms_key_arn      = join("", data.aws_kms_key.this.*.arn)
  iam_role_arn     = local.iam_role_enabled ? join("", aws_iam_role.this.*.arn) : var.existing_iam_role_arn
}

data "aws_region" "this" {
  count = local.iam_role_enabled ? 1 : 0
}

# Get information about the KMS Key used to encrypt secrets in AWS Secrets Manager
# If `kms_key_id` is not provided, use the AWS account's default CMK (the one named `aws/secretsmanager`)
data "aws_kms_key" "this" {
  count  = local.iam_role_enabled ? 1 : 0
  key_id = var.kms_key_id != null && var.kms_key_id != "" ? var.kms_key_id : "alias/aws/secretsmanager"
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

  statement {
    sid = "AllowRdsToUseKmsKeyToDecryptSecretValuesInSecretsManager"

    actions = [
      "kms:Decrypt"
    ]

    resources = [
      local.kms_key_arn
    ]

    condition {
      test     = "StringEquals"
      values   = [format("secretsmanager.%s.amazonaws.com", join("", data.aws_region.this.*.name))]
      variable = "kms:ViaService"
    }
  }
}

module "role_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

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
  role       = join("", aws_iam_role.this.*.name)
}
