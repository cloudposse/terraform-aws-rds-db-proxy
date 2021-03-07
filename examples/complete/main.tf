provider "aws" {
  region = var.region
}

resource "random_password" "admin_password" {
  count  = var.database_password == "" || var.database_password == null ? 1 : 0
  length = 33
  # Leave special characters out to avoid quoting and other issues.
  # Special characters have no additional security compared to increasing length.
  special          = false
  override_special = "!#$%^&*()<>-_"
}

locals {
  database_password = var.database_password != "" && var.database_password != null ? var.database_password : join("", random_password.admin_password.*.result)

  username_password = {
    username = var.database_user
    password = local.database_password
  }

  auth = [
    {
      auth_scheme = "SECRETS"
      description = "Access the database instance using username and password from AWS Secrets Manager"
      iam_auth    = "DISABLED"
      secret_arn  = aws_secretsmanager_secret.rds_username_and_password.arn
    }
  ]

  security_group_id = module.vpc.vpc_default_security_group_id
}

module "rds_instance" {
  source  = "cloudposse/rds/aws"
  version = "0.34.0"

  database_name       = var.database_name
  database_user       = var.database_user
  database_password   = local.database_password
  database_port       = var.database_port
  multi_az            = var.multi_az
  storage_type        = var.storage_type
  allocated_storage   = var.allocated_storage
  storage_encrypted   = var.storage_encrypted
  engine              = var.engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  db_parameter_group  = var.db_parameter_group
  publicly_accessible = var.publicly_accessible
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.subnets.private_subnet_ids
  security_group_ids  = [local.security_group_id]
  apply_immediately   = var.apply_immediately

  context = module.this.context
}

resource "aws_secretsmanager_secret" "rds_username_and_password" {
  name                    = module.this.id
  description             = "RDS username and password"
  recovery_window_in_days = 0
  tags                    = module.this.tags
}

resource "aws_secretsmanager_secret_version" "rds_username_and_password" {
  secret_id     = aws_secretsmanager_secret.rds_username_and_password.id
  secret_string = jsonencode(local.username_password)
}

module "rds_proxy" {
  source = "../../"

  db_instance_identifier = module.rds_instance.instance_id
  auth                   = local.auth
  vpc_security_group_ids = [local.security_group_id]
  vpc_subnet_ids         = module.subnets.private_subnet_ids

  debug_logging                = var.debug_logging
  engine_family                = var.engine_family
  idle_client_timeout          = var.idle_client_timeout
  require_tls                  = var.require_tls
  connection_borrow_timeout    = var.connection_borrow_timeout
  init_query                   = var.init_query
  max_connections_percent      = var.max_connections_percent
  max_idle_connections_percent = var.max_idle_connections_percent
  session_pinning_filters      = var.session_pinning_filters
  existing_iam_role_arn        = var.existing_iam_role_arn

  context = module.this.context
}
