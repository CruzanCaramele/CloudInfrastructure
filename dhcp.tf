#---------------------------------------------#
# DHCP Options #
#---------------------------------------------#
resource "aws_vpc_dhcp_options" "ottodhcp" {
  domain_name         = "${var.dns_zone}"
  domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${aws_vpc.otto_vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.ottodhcp.id}"
}
