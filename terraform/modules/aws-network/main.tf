resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"
  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets_cidr[count.index]
  availability_zone       = "${var.availability_zones[count.index]}"
  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = "${var.availability_zones[count.index]}"
  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_eip" "custom_eip" {
  count = "${var.num_of_eips}"
  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count = "${var.number_of_nat_gws}"
  allocation_id = [for i in "${aws_eip.custom_eip.*.id}" : i]                
  subnet_id     = [for i in "${aws_subnet.private.*.id}" : i]  //"${var.subnet_ids[count.index]}"

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "igw_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "pvt_rt" {
  count  = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.main.id

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_route" "eks_nat_gw_route1" {
  count = "${var.number_of_nat_gws}"
  route_table_id            = aws_route_table.pvt_rt[count.index]
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.nat_gw[count.index]
}

resource "aws_route_table_association" "pvt" {
  subnet_id      = [for i in "${aws_subnet.private.*.id}" : i]
  route_table_id = [for i in "${aws_route_table.pvt_rt.*.id}" : i] 
}

resource "aws_route_table" "nat_rt2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Environment = "${var.environment}"
  }
}

/* resource "aws_route" "eks_nat_gw_route2" {
  route_table_id            = aws_route_table.nat_rt2.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.nat_gw[count.index]  //[for i in "${aws_subnet.private.*.id}" : i]
} */

resource "aws_route_table_association" "rta2" {
  subnet_id      = [for i in "${aws_subnet.private.*.id}" : i]
  route_table_id = aws_route_table.nat_rt2.id
}