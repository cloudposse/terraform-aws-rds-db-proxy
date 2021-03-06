module "sg_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  attributes = ["all", "traffic"]
  context    = module.this.context
}

resource "aws_security_group" "this" {
  name                   = module.sg_label.id
  description            = "RDS Proxy Security Group"
  revoke_rules_on_delete = true
  vpc_id                 = module.vpc.vpc_id
  tags                   = module.sg_label.tags
}

resource "aws_security_group_rule" "egress" {
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "ingress" {
  description       = "Allow all ingress traffic"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.this.id
}
