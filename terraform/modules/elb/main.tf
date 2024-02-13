resource "aws_lb" "lb" {
  name               = "${var.environment}-${var.name}"
  internal = false
  load_balancer_type = "${var.load_balancer_type}"
  security_groups    = "${var.security_group_id}"
  subnets            = ["${var.subnet_ids}"]

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Name = "${var.environment}-${var.name}"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.environment}-${var.name}-tg"
  port     = "${var.port}"
  protocol = "${var.protocol}"
  target_type = instance
  vpc_id   = "${var.vpc_id}"

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    port = 80
    timeout             = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "${var.port}"
  protocol          = "${var.protocol}"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.certificate_arn}"

  default_action {
    type             = "${var.default_action_type}"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "nginx" {
  count = length(var.target_id)

  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = var.target_id[count.index]
  port             = 80
}