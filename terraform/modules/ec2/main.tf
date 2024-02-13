resource "aws_instance" "nginx" {
  count         = var.instance_count
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.subnet_id}"
  key_name      = "${var.key_name}"
  vpc_security_group_ids = "${var.security_groups_ids}"
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              echo 'Hello World from Nginx' | sudo tee /var/www/html/index.html
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF  
  tags = {
    Name = "${var.environment}_${var.ec2_name}"
  }
}