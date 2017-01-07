provider "aws" {
  region = "ap-southeast-2"
}

module "my_elb" {
  source = "../modules/elb"
  subnets = ["subnet-481d083f", "subnet-303cd454"]
  security_groups = ["sg-e8ac308c"]
}

module "my_lc" {
  source = "../modules/lc"
  subnets = ["subnet-481d083f", "subnet-303cd454"]
  security_groups = ["sg-e8ac308c"]
  snapshot_id = "snap-00d5e8ef70d1b3e24"
}

module "my_asg" {
  source = "../modules/asg"
  subnets = ["subnet-481d083f", "subnet-303cd454"]
  my_asg_name = "my_asg_${module.my_lc.my_lc_name}"
  my_lc_id = "${module.my_lc.my_lc_id}"
  my_elb_name = "${module.my_elb.my_elb_name}"
}
