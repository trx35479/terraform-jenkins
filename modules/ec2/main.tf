# Spinning instance with datasource

resource "aws_instance" "vha-instance" {
  ami                    = "${var.IMAGE_ID}"
  count                  = "${element(var.COUNT, 0) == "true" ? element(var.COUNT, 1) : 0}"
  instance_type          = "${var.FLAVOR}"
  subnet_id              = "${element(var.SUBNET_ID, count.index)}"
  vpc_security_group_ids = ["${var.VPC_SECURITY_GROUP_IDS}"]
  key_name               = "${var.AWS_KEYPAIR}"

  tags {
    Name     = "${element(var.TAGS, 0)}-${count.index +1}"
    Owner    = "${element(var.TAGS, 1)}"
    Schedule = "${element(var.TAGS, 2)}"
  }
}
