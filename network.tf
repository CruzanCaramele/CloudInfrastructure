#---------------------------------------------#
# VPC #
#---------------------------------------------#
resource "aws_vpc" "otto_vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

#---------------------------------------------#
# Public Subnet A #
#---------------------------------------------#
resource "aws_subnet" "public_webserver_zone_a" {
  vpc_id            = "${aws_vpc.otto_vpc.id}"
  cidr_block        = "${var.public_subnet_server_a_cidr}"
  availability_zone = "us-east-1a"

  tags {
    Name = "Public Web Server Zone A"
  }
}

resource "aws_route_table_association" "public_webserver_zone_a" {
  subet_id       = "${aws_subnet.public_webserver_zone_a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

#---------------------------------------------#
# Public Subnet B #
#---------------------------------------------#
resource "aws_subnet" "public_webserver_zone_b" {
  vpc_id            = "${aws_vpc.otto_vpc.id}"
  cidr_block        = "${var.public_subnet_server_b_cidr}"
  availability_zone = "us-east-1b"

  tags {
    Name = "Public Web Server Zone B"
  }
}

resource "aws_route_table_association" "public_webserver_zone_b" {
  subet_id       = "${aws_subnet.public_webserver_zone_b.id}"
  route_table_id = "${aws_route_table.public.id}"
}

#---------------------------------------------#
# Bastion Hosts Subnets #
#---------------------------------------------#
resource "aws_subnet" "public_bastion_zone_a" {
  vpc_id            = "${aws_vpc.otto_vpc.id}"
  cidr_block        = "${var.public_subnet_bastion_a_cidr}"
  availability_zone = "us-east-1a"

  tags {
    Name = "Public Bastion Server Zone A"
  }
}

resource "aws_route_table_association" "public_bastion_zone_a" {
  subet_id       = "${aws_subnet.public_bastion_zone_a}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "public_bastion_zone_b" {
  vpc_id            = "${aws_vpc.otto_vpc.id}"
  cidr_block        = "${var.public_subnet_bastion_b_cidr}"
  availability_zone = "us-east-1b"

  tags {
    Name = "Public Bastion Server Zone B"
  }
}

resource "aws_route_table_association" "public_bastion_zone_b" {
  subet_id       = "${aws_subnet.public_bastion_zone_b}"
  route_table_id = "${aws_route_table.public.id}"
}

#---------------------------------------------#
# Database Servers Subnets #
#---------------------------------------------#
resource "aws_subnet" "private_db_zone_a" {
  vpc_id            = "${aws_vpc.otto_vpc.id}"
  cidr_block        = "${var.private_subnet_db_a_cidr}"
  availability_zone = "us-east-1a"

  tags {
    Name = "Priavte Database Server Zone A"
  }
}

resource "aws_route_table_association" "private_db_zone_a" {
  subet_id       = "${aws_subnet.private_db_zone_a}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_subnet" "private_db_zone_b" {
  vpc_id            = "${aws_vpc.otto_vpc.id}"
  cidr_block        = "${var.private_subnet_db_b_cidr}"
  availability_zone = "us-east-1b"

  tags {
    Name = "Priavte Database Server Zone B"
  }
}

resource "aws_route_table_association" "private_db_zone_b" {
  subet_id       = "${aws_subnet.private_db_zone_b}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_db_subnet" "database" {
  name        = "database"
  descriotion = "main group subnets"
  subnet_ids  = ["${aws_subnet.private_db_zone_a.id}", "${aws_subnet.private_db_zone_b.id}"]
}
