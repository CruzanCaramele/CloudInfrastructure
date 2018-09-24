#---------------------------------------------#
# Internet Gateway #
#---------------------------------------------#
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.otto_vpc.id}"

  tags {
    Name = "igw for vpc"
  }
}

#---------------------------------------------#
# Public  route table #
#---------------------------------------------#
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.otto_vpc.id}"

  tags {
    Name = "Public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

#---------------------------------------------#
# Private  route table #
#---------------------------------------------#
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.otto_vpc.id}"

  tags {
    Name = "Private"
  }

  route {
    cidr_block     = "0.0.0.0/16"
    nat_gateway_id = "${aws_nat_gateway.public_webserver_zone_a.id}"
  }
}

#---------------------------------------------#
# Main route table #
#---------------------------------------------#
resource "aws_main_route_table_association" "new_main_route_table" {
  vpc_id         = "${aws_vpc.otto_vpc.id}"
  route_table_id = "${aws_route_table.public.id}"
}

#---------------------------------------------#
# NAT Gateway #
#---------------------------------------------#
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "public_webserver_zone_a" {
  subnet_id     = "${aws_subnet.public_webserver_zone_a.id}"
  depends_on    = ["aws_internet_gateway.igw"]
  allocation_id = "${aws_eip.nat_eip.id}"
}
