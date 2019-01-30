variable "AWS_ACCESS_KEY_ID" {}

variable "AWS_SECRET_ACCESS_KEY" {}

variable "AWS_REGION" {
  default = "ap-southeast-2"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "~/.ssh/id_rsa.pub"
}

variable "CLUSTER_NAME" {
  default = "vha"
}
