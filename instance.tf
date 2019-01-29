# Instantiating the module

provider "aws" {
  region = "${var.AWS_REGION}"
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "${var.CLUSTER_NAME}-mykeypair"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

module "vha-instance" {
  source = "modules/ec2"

  AWS_KEYPAIR            = "${aws_key_pair.mykeypair.key_name}"
  IMAGE_ID               = "${data.aws_ami.unico-centos-ami.id}"
  FLAVOR                 = "t2.micro"
  SUBNET_ID              = "${data.aws_subnet_ids.unico-private-subnets.ids}"
  VPC_SECURITY_GROUP_IDS = "${data.aws_security_groups.unico-security-groups.ids}"
  COUNT                  = ["true", 1]
  TAGS                   = ["Unico-VHA", "DevOps", "10x5"]
}

output "private_ips" {
  value = "${module.vha-instance.private_ips}"
}
