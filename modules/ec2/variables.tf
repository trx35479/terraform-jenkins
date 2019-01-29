variable "IMAGE_ID" {}

variable "FLAVOR" {}

variable "COUNT" {
  type = "list"
}

variable "VPC_SECURITY_GROUP_IDS" {
  type = "list"
}

variable "AWS_KEYPAIR" {}

variable "SUBNET_ID" {
  type = "list"
}

variable "TAGS" {
  type = "list"
}
