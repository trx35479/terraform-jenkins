# Extract custom amis, vpc-id, security groups and subnet-ids
data "aws_ami" "unico-centos-ami" {
  most_recent = true
  owners      = ["279459402216"]

  filter {
    name   = "name"
    values = ["Centos7.5_Unico_Java"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "unico-vpc" {
  filter {
    name   = "owner-id"
    values = ["279459402216"]
  }

  tags {
    Name  = "unico-corporate"
    Owner = "UnicoDevOps"
  }
}

data "aws_subnet_ids" "unico-private-subnets" {
  vpc_id = "${data.aws_vpc.unico-vpc.id}"

  tags {
    Name = "Unico-Corporate-Private-*"
  }
}

data "aws_security_groups" "unico-security-groups" {
  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.unico-vpc.id}"]
  }

  tags {
    Owner = "UnicoDevOps"
  }
}
