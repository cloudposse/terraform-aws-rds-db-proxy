<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 3.1.15 |
| null | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.1.15 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| role_label | cloudposse/label/null | 0.24.1 |
| this | cloudposse/label/null | 0.24.1 |

## Resources

| Name |
|------|
| [aws_db_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy) |
| [aws_db_proxy_default_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_default_target_group) |
| [aws_db_proxy_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_target) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| auth | Configuration blocks with authorization mechanisms to connect to the associated database instances or clusters | <pre>list(object({<br>    auth_scheme = string<br>    description = string<br>    iam_auth    = string<br>    secret_arn  = string<br>  }))</pre> | n/a | yes |
| connection\_borrow\_timeout | he number of seconds for a proxy to wait for a connection to become available in the connection pool. Only applies when the proxy has opened its maximum number of connections and all connections are busy with client sessions | `number` | `120` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| db\_cluster\_identifier | DB cluster identifier. Either `db_instance_identifier` or `db_cluster_identifier` should be specified and both should not be specified together | `string` | `null` | no |
| db\_instance\_identifier | DB instance identifier. Either `db_instance_identifier` or `db_cluster_identifier` should be specified and both should not be specified together | `string` | `null` | no |
| debug\_logging | Whether the proxy includes detailed information about SQL statements in its logs | `bool` | `false` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| engine\_family | The kinds of databases that the proxy can connect to. This value determines which database network protocol the proxy recognizes when it interprets network traffic to and from the database. The engine family applies to MySQL and PostgreSQL for both RDS and Aurora. Valid values are MYSQL and POSTGRESQL | `string` | `"MYSQL"` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| existing\_iam\_role\_arn | The ARN of an existing IAM role that the proxy can use to access secrets in AWS Secrets Manager. If not provided, the module will create a role to access secrets in Secrets Manager | `string` | `null` | no |
| iam\_role\_attributes | Additional attributes to add to the ID of the IAM role that the proxy uses to access secrets in AWS Secrets Manager | `list(string)` | `null` | no |
| id\_length\_limit | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| idle\_client\_timeout | The number of seconds that a connection to the proxy can be inactive before the proxy disconnects it | `number` | `1800` | no |
| init\_query | One or more SQL statements for the proxy to run when opening each new database connection | `string` | `null` | no |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| max\_connections\_percent | The maximum size of the connection pool for each target in a target group | `number` | `100` | no |
| max\_idle\_connections\_percent | Controls how actively the proxy closes idle database connections in the connection pool. A high value enables the proxy to leave a high percentage of idle connections open. A low value causes the proxy to close idle client connections and return the underlying database connections to the connection pool | `number` | `50` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| require\_tls | A Boolean parameter that specifies whether Transport Layer Security (TLS) encryption is required for connections to the proxy. By enabling this setting, you can enforce encrypted TLS connections to the proxy | `bool` | `false` | no |
| session\_pinning\_filters | Each item in the list represents a class of SQL operations that normally cause all later statements in a session using a proxy to be pinned to the same underlying database connection | `list(string)` | `null` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| vpc\_security\_group\_ids | One or more VPC security group IDs to associate with the proxy | `set(string)` | n/a | yes |
| vpc\_subnet\_ids | One or more VPC subnet IDs to associate with the proxy | `set(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| proxy\_arn | Proxy ARN |
| proxy\_default\_target\_group\_arn | The Amazon Resource Name (ARN) representing the default target group |
| proxy\_default\_target\_group\_name | The name of the default target group |
| proxy\_endpoint | Proxy endpoint |
| proxy\_iam\_role\_arn | The ARN of the IAM role that the proxy uses to access secrets in AWS Secrets Manager |
| proxy\_id | Proxy ID |
| proxy\_target\_endpoint | Hostname for the target RDS DB Instance. Only returned for `RDS_INSTANCE` type |
| proxy\_target\_id | Identifier of `db_proxy_name`, `target_group_name`, `target type` (e.g. `RDS_INSTANCE` or `TRACKED_CLUSTER`), and resource identifier separated by forward slashes (`/`) |
| proxy\_target\_port | Port for the target RDS DB instance or Aurora DB cluster |
| proxy\_target\_rds\_resource\_id | Identifier representing the DB instance or DB cluster target |
| proxy\_target\_target\_arn | Amazon Resource Name (ARN) for the DB instance or DB cluster |
| proxy\_target\_tracked\_cluster\_id | DB Cluster identifier for the DB instance target. Not returned unless manually importing an `RDS_INSTANCE` target that is part of a DB cluster |
| proxy\_target\_type | Type of target. e.g. `RDS_INSTANCE` or `TRACKED_CLUSTER` |
<!-- markdownlint-restore -->
