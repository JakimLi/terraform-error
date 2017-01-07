resource "aws_elb" "my_elb" {
  name = "my-elb"
  subnets = ["${var.subnets}"]
  security_groups = ["${var.security_groups}"]
  internal = true

  lifecycle {
    create_before_destroy = true
  }

  listener {
    instance_port = 9090
    instance_protocol = "http"
    lb_port = "80"
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    target = "http:9090/"
    interval = 10
  }

  tags {
    MyTag = "TEST"
  }
}
