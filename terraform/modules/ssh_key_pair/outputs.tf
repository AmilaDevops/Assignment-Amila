output "key_pair_key_name" {
  value = "${aws_key_pair.key_pair.key_name}"
}
output "private_key_pem" {
  value = "${tls_private_key.key_pair.private_key_pem}"
}