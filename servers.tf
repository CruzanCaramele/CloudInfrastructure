#---------------------------------------------#
# AMI Data Source #
#---------------------------------------------#
data "aws_ami" "servers_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#---------------------------------------------#
# Database Instance #
#---------------------------------------------#
resource "aws_db_instance" "otto_db" {
  name                   = "otto_db"
  engine                 = "mysql"
  username               = "administrator"
  password               = "sup3rs3cr3tpassw0rd"
  storage_type           = "gp2"
  engine_version         = "5.7"
  instance_class         = "${var.db_instance_class}"
  allocated_storage      = 10
  skip_final_snapshot    = true
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = "${aws_db_subnet_group.database.id}"
  vpc_security_group_ids = ["${aws_security_group.db_server.id}"]
}

#---------------------------------------------#
# Web Server Instances #
#---------------------------------------------#
resource "aws_instance" "webserver_a" {
  ami                         = "${data.aws_ami.servers_ami.id}"
  key_name                    = "${var.permit_key}"
  subnet_id                   = "${aws_subnet.public_webserver_zone_a.id}"
  instance_type               = "${var.webserver_instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.webserver_profile.id}"
  vpc_security_group_ids      = ["${aws_security_group.webserver_zone_a.id}"]
  associate_public_ip_address = "true"

  tags {
    Name = "Webserver_Zone_A"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update; sudo apt-get -y install awscli
    sudo mkdir /srv/www
    aws s3 cp s3://"${aws_s3_bucket.otto_bucket.bucket}"/server-files.tar.gz /srv/www/server-files.tar.gz
    aws s3 cp s3://"${aws_s3_bucket.otto_bucket.bucket}"/bootstrap.sh /tmp/bootstrap.sh
    sudo chmod +x /tmp/bootstrap.sh
    sudo /tmp/bootstrap.sh > /tmp/stdout.txt 2> /tmp/stderr.txt
    EOF
}

resource "aws_instance" "webserver_b" {
  ami                         = "${data.aws_ami.servers_ami.id}"
  key_name                    = "${var.permit_key}"
  subnet_id                   = "${aws_subnet.public_webserver_zone_b.id}"
  instance_type               = "${var.webserver_instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.webserver_profile.id}"
  vpc_security_group_ids      = ["${aws_security_group.webserver_zone_b.id}"]
  associate_public_ip_address = "true"

  tags {
    Name = "Webserver_Zone_B"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update; sudo apt-get -y install awscli
    sudo mkdir /srv/www
    ws s3 cp s3://"${aws_s3_bucket.otto_bucket.bucket}"/server-files.tar.gz /srv/www/server-files.tar.gz
    aws s3 cp s3://"${aws_s3_bucket.otto_bucket.bucket}"/bootstrap.sh /tmp/bootstrap.sh
    sudo chmod +x /tmp/bootstrap.sh
    sudo /tmp/bootstrap.sh > /tmp/stdout.txt 2> /tmp/stderr.txt
    EOF
}

#---------------------------------------------#
# Bastion Instances #
#---------------------------------------------#
resource "aws_instance" "bastion_server_a" {
  ami                         = "${data.aws_ami.servers_ami.id}"
  key_name                    = "${var.permit_key}"
  subnet_id                   = "${aws_subnet.public_bastion_zone_a.id}"
  instance_type               = "${var.webserver_instance_type}"
  vpc_security_group_ids      = ["${aws_security_group.bastion_server.id}"]
  associate_public_ip_address = "true"

  tags {
    Name = "Bastion_Server_A"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get -y update; sudo apt-get -y upgrade
    EOF
}

resource "aws_instance" "bastion_server_b" {
  ami                         = "${data.aws_ami.servers_ami.id}"
  key_name                    = "${var.permit_key}"
  subnet_id                   = "${aws_subnet.public_bastion_zone_b.id}"
  instance_type               = "${var.webserver_instance_type}"
  vpc_security_group_ids      = ["${aws_security_group.bastion_server.id}"]
  associate_public_ip_address = "true"

  tags {
    Name = "Bastion_Server_B"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get -y update; sudo apt-get -y upgrade
    EOF
}
