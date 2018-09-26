#---------------------------------------------#
# Route53 Zone & Record #
#---------------------------------------------#
resource "aws_route53_zone" "primary" {
  name   = "${var.dns_zone}"
  vpc_id = "${aws_vpc.otto_vpc.id}"
}

resource "aws_route53_record" "database_record" {
  ttl     = "60"
  type    = "CNAME"
  name    = "database.${var.dns_zone}"
  zone_id = "${aws_route53_zone.primary.zone_id}"
  records = ["${aws_db_instance.otto_db.address}"]
}
