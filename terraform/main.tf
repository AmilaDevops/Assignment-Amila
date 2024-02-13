module "aws-network" {
  source = "./modules/aws-network"
  cidr_block = "TF_VAR_cidr_block"
  region = "ap-southeast-1"
  vpc_name = "Dev-Vpc"
  enable_dns_support = true
  enable_dns_hostnames = true
  availability_zones = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets_cidr = ["192.168.1.0/24","192.168.2.0/24"]
  public_subnets_cidr  = ["192.168.3.0/24","192.168.4.0/24"]
  environment = "production"
  number_of_nat_gws = "2"
  num_of_eips = "2"
}

module "ssh_key_pair" {
    source = "./modules/ssh_key_pair"
    environment = "production"
    name = "nginx_ec2_key_pair"
}

module "aws-alb-securitygroups" {
    source = "./modules/aws-securitygroups/alb-sg"
 
    vpc_id = "${module.aws-network.vpc_id}"
    environment = "production"
    security_group_name = "alb-sg"
}

module "aws-ec2-securitygroups" {
    source = "./modules/aws-securitygroups/ec2-nginx-sg"
    vpc_id = "${module.aws-network.vpc_id}"
    environment = "production"
    security_group_name = "ec2-nginx-sg"
    ingress_source_security_group_id = "${module.aws-alb-securitygroups.security_group_id_alb}"
}

module "ec2" {
  source         = "./modules/ec2"
  instance_count = 2
  ami = "ami-123456" # Update this with a valid AMI ID
  instance_type = "t2.micro"
  security_groups_ids = ["module.aws-ec2-securitygroups.security_group_id"]
  ec2_name = "nginx-ec2"
  subnet_id        = module.aws-network.private_subnet_ids
  environment = "production"
  key_name    = module.ssh_key_pair.key_pair_key_name
  depends_on = [module.aws-ec2-securitygroups]
  
}

module "acm" {
    source = "./modules/acm"
    name = "nginx_acm"
    environment = "production"
    domain_name = "prod.ceylondevops.com"
    validation_method = "DNS"
    zone_id = "Z0486576KMEHGCQRW47T"
  

    ttl = 60
    allow_overwrite = false
}

module "elb" {
  source  = "./modules/elb"
  name = "public-alb"
  environment = "production"
  load_balancer_type = "application"
  vpc_id  = "${module.aws-network.vpc_id}"
  subnet_ids =  module.aws-network.public_subnet_ids
  security_group_id = module.aws-alb-securitygroups.security_group_id_alb
  port = 443
  protocol = "HTTPS"
  certificate_arn = module.acm.certificate_arn
  default_action_type = "forward"
  target_group_name = "production-public-alb-tg"
  target_id = "${module.ec2.ids}"
}