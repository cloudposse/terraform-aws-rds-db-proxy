region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b"]

namespace = "eg"

stage = "test"

name = "rds-proxy"

deletion_protection = false

database_name = "test_db"

database_user = "admin_user"

database_port = 5432

multi_az = false

storage_type = "standard"

storage_encrypted = false

allocated_storage = 5

publicly_accessible = false

apply_immediately = true

# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html
# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_WorkingWithParamGroups.html
# aws rds describe-db-engine-versions --engine postgres --region=us-east-1
# aws rds describe-db-engine-versions --query "DBEngineVersions[].DBParameterGroupFamily" --engine postgres --region=us-east-1
engine = "postgres"

engine_version = "11.10"

db_parameter_group = "postgres11"

# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
instance_class = "db.t2.small"
