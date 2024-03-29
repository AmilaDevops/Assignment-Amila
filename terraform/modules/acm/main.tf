resource "aws_acm_certificate" "eks_acm" {
  domain_name       = "${var.domain_name}"
  validation_method = "${var.validation_method}"
  tags = {
    Name = "${var.environment}_${var.name}"
  }
}

resource "aws_route53_record" "eks_acm_records" {
  for_each = {
    for dvo in aws_acm_certificate.eks_acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = "${var.allow_overwrite}"
  name            = each.value.name
  records         = [each.value.record]
  ttl             = "${var.ttl}"
  type            = each.value.type
  zone_id         = "${var.zone_id}"
}

resource "aws_acm_certificate_validation" "eks_acm_validation" {
  certificate_arn         = "${aws_acm_certificate.eks_acm.arn}"
  validation_record_fqdns = [for record in aws_route53_record.eks_acm_records : record.fqdn]
}
