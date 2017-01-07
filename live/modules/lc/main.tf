data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.sh")}"

  vars {
    notify_email = "my@email.co"
  }
}

resource "aws_launch_configuration" "my_lc" {
  lifecycle {
    create_before_destroy = true
  }
  image_id = "ami-9be6f38c"
  instance_type = "t2.micro"
  security_groups = ["${var.security_groups}"]
  iam_instance_profile = "profile-name"
  user_data = "${data.template_file.userdata.rendered}"
  associate_public_ip_address = false

  root_block_device {
    volume_size = 20
  }

  ebs_block_device {
    device_name = "/dev/sdi"
    volume_size = 10
    snapshot_id = "${var.snapshot_id}"
  }
}
