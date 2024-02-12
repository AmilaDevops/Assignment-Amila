output "certificate_arn" {
  value = "${aws_acm_certificate.eks_acm.arn}"
}