resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.environment}_${var.name}"
  public_key = tls_private_key.key_pair.public_key_openssh

  provisioner "local-exec" { # Create a "Key.pem" to your computer!!
    command = "echo '${tls_private_key.key_pair.private_key_pem}' > ./${var.environment}_${var.name}.pem"
  }
}