resource "aws_autoscaling_group" "my_asg" {
  name = "${var.my_asg_name}"
  lifecycle {
    create_before_destroy = true
  }
  max_size = 1
  min_size = 1
  vpc_zone_identitfier = ["${var.subnets}"]
  wait_for_elb_capacity = true
  wait_for_capacity_timeout = "15m"
  min_elb_capacity = 1
  launch_configuration = "${var.my_lc_id}"
  load_balancers = ["${var.my_elb_name}"]
  tag {
    key = "Role"
    value = "API"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name = "scale_up"
  lifecycle { create_before_destroy = true }
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.my_asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name = "high_cpu"
  lifecycle  { create_before_destroy = true }
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "80"
  insufficient_data_actions = []
  alarm_description = "EC2 CPU Utilization"
  alarm_actions = ["${aws_autoscaling_policy.scale_up.arn}"]
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.my_asg.name}"
  }
}

resource "aws_autoscaling_policy" "scale_down" {
  name = "scale_down"
  lifecycle { create_before_destroy = true }
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 600
  autoscaling_group_name = "${aws_autoscaling_group.my_asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name = "low_cpu"
  lifecycle  { create_before_destroy = true }
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "5"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "300"
  insufficient_data_actions = []
  alarm_description = "EC2 CPU Utilization"
  alarm_actions = ["${aws_autoscaling_policy.scale_down.arn}"]
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.my_asg.name}"
  }
}
