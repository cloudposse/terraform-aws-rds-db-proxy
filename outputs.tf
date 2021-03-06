output "proxy_id" {
  value       = aws_db_proxy.this.id
  description = "Proxy ID"
}

output "proxy_arn" {
  value       = aws_db_proxy.this.arn
  description = "Proxy ARN"
}

output "proxy_endpoint" {
  value       = aws_db_proxy.this.endpoint
  description = "Proxy endpoint"
}

output "proxy_target_endpoint" {
  value       = aws_db_proxy_target.this.endpoint
  description = "Hostname for the target RDS DB Instance. Only returned for `RDS_INSTANCE` type"
}

output "proxy_target_id" {
  value       = aws_db_proxy_target.this.id
  description = "Identifier of `db_proxy_name`, `target_group_name`, `target type` (e.g. `RDS_INSTANCE` or `TRACKED_CLUSTER`), and resource identifier separated by forward slashes (`/`)"
}

output "proxy_target_port" {
  value       = aws_db_proxy_target.this.port
  description = "Port for the target RDS DB instance or Aurora DB cluster"
}

output "proxy_target_rds_resource_id" {
  value       = aws_db_proxy_target.this.rds_resource_id
  description = "Identifier representing the DB instance or DB cluster target"
}

output "proxy_target_target_arn" {
  value       = aws_db_proxy_target.this.target_arn
  description = "Amazon Resource Name (ARN) for the DB instance or DB cluster"
}

output "proxy_target_tracked_cluster_id" {
  value       = aws_db_proxy_target.this.tracked_cluster_id
  description = "DB Cluster identifier for the DB instance target. Not returned unless manually importing an `RDS_INSTANCE` target that is part of a DB cluster"
}

output "proxy_target_type" {
  value       = aws_db_proxy_target.this.type
  description = "Type of target. e.g. `RDS_INSTANCE` or `TRACKED_CLUSTER`"
}

output "proxy_default_target_group_arn" {
  value       = aws_db_proxy_default_target_group.this.arn
  description = "The Amazon Resource Name (ARN) representing the default target group"
}

output "proxy_default_target_group_name" {
  value       = aws_db_proxy_default_target_group.this.name
  description = "The name of the default target group"
}
