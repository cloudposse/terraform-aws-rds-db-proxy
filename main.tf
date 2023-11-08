locals {
  enabled = module.this.enabled
}

resource "aws_db_proxy" "this" {
  count = local.enabled ? 1 : 0

  name                   = module.this.id
  debug_logging          = var.debug_logging
  engine_family          = var.engine_family
  idle_client_timeout    = var.idle_client_timeout
  require_tls            = var.require_tls
  role_arn               = local.iam_role_arn
  vpc_security_group_ids = var.vpc_security_group_ids
  vpc_subnet_ids         = var.vpc_subnet_ids

  dynamic "auth" {
    for_each = var.auth

    content {
      auth_scheme = auth.value.auth_scheme
      description = auth.value.description
      iam_auth    = auth.value.iam_auth
      secret_arn  = auth.value.secret_arn
    }
  }

  tags = module.this.tags

  timeouts {
    create = var.proxy_create_timeout
    update = var.proxy_update_timeout
    delete = var.proxy_delete_timeout
  }
}

resource "aws_db_proxy_default_target_group" "this" {
  count = local.enabled ? 1 : 0

  db_proxy_name = join("", aws_db_proxy.this[*].name)

  dynamic "connection_pool_config" {
    for_each = (
      var.connection_borrow_timeout != null || var.init_query != null || var.max_connections_percent != null ||
      var.max_idle_connections_percent != null || var.session_pinning_filters != null
    ) ? ["true"] : []

    content {
      connection_borrow_timeout    = var.connection_borrow_timeout
      init_query                   = var.init_query
      max_connections_percent      = var.max_connections_percent
      max_idle_connections_percent = var.max_idle_connections_percent
      session_pinning_filters      = var.session_pinning_filters
    }
  }
}

resource "aws_db_proxy_target" "this" {
  count = local.enabled ? 1 : 0

  db_instance_identifier = var.db_instance_identifier
  db_cluster_identifier  = var.db_cluster_identifier
  db_proxy_name          = join("", aws_db_proxy.this[*].name)
  target_group_name      = join("", aws_db_proxy_default_target_group.this[*].name)
}

resource "aws_db_proxy_endpoint" "this" {
   count = local.enabled ? 1 : 0

   db_proxy_name          = join("", aws_db_proxy.this[*].name)
   db_proxy_endpoint_name = join("-", [join("", aws_db_proxy.this[*].name), "read-only"])
   vpc_subnet_ids         = var.vpc_subnet_ids
   target_role            = "READ_ONLY"
 } 