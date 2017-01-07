provider "aws" {
  region = "ap-southeast-2"
}

module "my_elb" {
  source = "../modules/elb"
  subnets = ["subnet-a0020d8f", "subnet-fb9c77f9"]
  security_groups = ["sg-3eff344e"]
}

module "my_lc" {
  source = "../modules/lc"
  security_groups = ["sg-3eff344e"]
  snapshot = "snap-0301ee02"
}

module "my_asg" {
  source = "../modules/asg"
  my_asg_name = "my_asg_${module.my_lc.my_lc_name}"
  my_lc_id = "${module.my_lc.my_lc_id}"
  my_elb_name = "${module.my_elb.my_elb_name}"
}
