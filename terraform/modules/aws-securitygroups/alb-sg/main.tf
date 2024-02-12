resource "aws_security_group" "security_group" {
  name        = "${var.environment}_${var.security_group_name}"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name = "${var.environment}_${var.security_group_name}"
    "${var.additional_tag_key}" = "${var.additional_tag_value}"
  }
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks      = "0.0.0.0/0"
  security_group_id = aws_security_group.security_group.id
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks      = "0.0.0.0/0"
  security_group_id = aws_security_group.security_group.id
}