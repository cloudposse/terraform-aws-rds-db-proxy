variable "debug_logging" {
  type        = bool
  default     = false
  description = "Whether the proxy includes detailed information about SQL statements in its logs"
}

variable "engine_family" {
  type        = string
  default     = "MYSQL"
  description = "The kinds of databases that the proxy can connect to. This value determines which database network protocol the proxy recognizes when it interprets network traffic to and from the database. The engine family applies to MySQL and PostgreSQL for both RDS and Aurora. Valid values are MYSQL and POSTGRESQL"
}

variable "idle_client_timeout" {
  type        = number
  default     = 1800
  description = "The number of seconds that a connection to the proxy can be inactive before the proxy disconnects it"
}

variable "require_tls" {
  type        = bool
  default     = false
  description = "A Boolean parameter that specifies whether Transport Layer Security (TLS) encryption is required for connections to the proxy. By enabling this setting, you can enforce encrypted TLS connections to the proxy"
}

variable "role_arn" {
  type        = string
  description = "he Amazon Resource Name (ARN) of the IAM role that the proxy uses to access secrets in AWS Secrets Manager"
}

variable "vpc_security_group_ids" {
  type        = set(string)
  description = "One or more VPC security group IDs to associate with the proxy"
}

variable "vpc_subnet_ids" {
  type        = set(string)
  description = "One or more VPC subnet IDs to associate with the proxy"
}

variable "auth" {
  type = list(object({
    auth_scheme = string
    description = string
    iam_auth    = string
    secret_arn  = string
  }))
  description = "Configuration blocks with authorization mechanisms to connect to the associated database instances or clusters"
}

variable "db_instance_identifier" {
  type        = string
  default     = null
  description = "DB instance identifier. Either `db_instance_identifier` or `db_cluster_identifier` should be specified and both should not be specified together"
}

variable "db_cluster_identifier" {
  type        = string
  default     = null
  description = "DB cluster identifier. Either `db_instance_identifier` or `db_cluster_identifier` should be specified and both should not be specified together"
}

variable "connection_borrow_timeout" {
  type        = number
  default     = 120
  description = "he number of seconds for a proxy to wait for a connection to become available in the connection pool. Only applies when the proxy has opened its maximum number of connections and all connections are busy with client sessions"
}

variable "init_query" {
  type        = string
  default     = null
  description = "One or more SQL statements for the proxy to run when opening each new database connection"
}

variable "max_connections_percent" {
  type        = number
  default     = 100
  description = "The maximum size of the connection pool for each target in a target group"
}

variable "max_idle_connections_percent" {
  type        = number
  default     = 50
  description = "Controls how actively the proxy closes idle database connections in the connection pool. A high value enables the proxy to leave a high percentage of idle connections open. A low value causes the proxy to close idle client connections and return the underlying database connections to the connection pool"
}

variable "session_pinning_filters" {
  type        = list(string)
  default     = null
  description = "Each item in the list represents a class of SQL operations that normally cause all later statements in a session using a proxy to be pinned to the same underlying database connection"
}
