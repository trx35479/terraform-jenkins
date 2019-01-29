# show the private_ips of the instances

output "private_ips" {
  value = "${aws_instance.vha-instance.*.private_ip}"
}
