resource "aws_security_group" "load_balancer_security_group" {
  name        = "load_balancer_security_group"
  description = "Set HTTP up for load balance"

  vpc_id = "${aws_vpc.otto_vpc.id}"

  # Http port
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outgoing connectinogs
  egress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "webserver_zone_a" {
  name        = "web server a"
  description = "Open up port for server"

  vpc_id = "${aws_vpc.otto_vpc.id}"

  # SSH port
  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "TCP"

    # Lock to bastions
    cidr_blocks = ["${var.public_subnet_bastion_a_cidr}", "${var.public_subnet_bastion_b_cidr}"]
  }

  # Http port
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outgoing connectinogs
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "webserver_zone_b" {
  name        = "web server b"
  description = "Open up port for server"

  vpc_id = "${aws_vpc.otto_vpc.id}"

  # SSH port
  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "TCP"

    # Lock to bastion
    cidr_blocks = ["${var.public_subnet_bastion_a_cidr}", "${var.public_subnet_bastion_b_cidr}"]
  }

  # Http port
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outgoing connectinogs
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion_server" {
  name        = "bastion_server"
  description = "Security group for bastion"

  vpc_id = "${aws_vpc.otto_vpc.id}"

  # SSH port
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

    # cidr_blocks = ["IP/32"]
  }

  # Outgoing connectinogs
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_server" {
  name        = "db_server"
  description = "Security group for DB"

  vpc_id = "${aws_vpc.otto_vpc.id}"

  # DB port
  ingress {
    from_port = "3306"
    to_port   = "3306"
    protocol  = "TCP"

    # Lock to web servers
    cidr_blocks = ["${var.public_subnet_server_a_cidr}", "${var.public_subnet_server_b_cidr}"]
  }

  # Outgoing connectinogs
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
