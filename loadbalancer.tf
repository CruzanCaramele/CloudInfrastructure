#---------------------------------------------#
# Application Load Balancer #
#---------------------------------------------#
resource "aws_lb" "otto_lb" {
  name               = "otto-lb"
  internal           = false
  subnets            = ["${aws_subnet.public_webserver_zone_a.id}", "${aws_subnet.public_webserver_zone_b.id}"]
  security_groups    = ["${aws_security_group.load_balancer_security_group.id}"]
  load_balancer_type = "application"
}

#---------------------------------------------#
# Target Group #
#---------------------------------------------#
resource "aws_alb_target_group" "lb_frontend_http" {
  name     = "lb_frontend_http"
  port     = "80"
  vpc_id   = "${aws_vpc.otto_vpc.id}"
  protocol = "HTTP"
}

#---------------------------------------------#
# Target Group Attachments #
#---------------------------------------------#
resource "aws_alb_target_group_attachment" "webserver_a_http" {
  port             = 80
  target_id        = "${aws_instance.webserver_a.id}"
  target_group_arn = "${aws_alb_target_group.lb_frontend_http.arn}"
}

resource "aws_alb_target_group_attachment" "webserver_b_http" {
  port             = 80
  target_id        = "${aws_instance.webserver_b.id}"
  target_group_arn = "${aws_alb_target_group.lb_frontend_http.arn}"
}

#---------------------------------------------#
# Load Balancer Listener #
#---------------------------------------------#
resource "aws_lb_listener" "frontend" {
  port              = "80"
  protocol          = "HTTP"
  load_balancer_arn = "${aws_lb.otto_lb.arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.lb_frontend_http.arn}"
  }
}
