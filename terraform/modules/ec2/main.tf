resource "aws_instance" "nginx" {
  count         = var.instance_count
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.subnet_id}"
  key_name      = "${var.key_name}"
  vpc_security_group_ids = "${var.security_groups_ids}"
  tags = {
    Name = "${var.environment}_${var.ec2_name}"
  }
}