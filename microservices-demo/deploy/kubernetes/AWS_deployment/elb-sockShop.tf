resource "aws_elb" "ci-sockshop-k8s-elb" {
  # depends_on = [ "aws_instance.ci-sockshop-k8s-node" ]
  name      = "ci-sockshop-k8s-elb"
  instances = "${aws_instance.ci-sockshop-k8s-node[*].id}"
  # availability_zones = ["${data.aws_availability_zones.available.names}"]
  availability_zones = ["eu-central-1a","eu-central-1b","eu-central-1c"]
  security_groups    = ["${aws_security_group.k8s-security-group.id}"]
  # vpc_security_group_ids = ["${aws_security_group.k8s-security-group.id}"] 
  listener {
    lb_port           = 80
    instance_port     = 30001
    lb_protocol       = "http"
    instance_protocol = "http"
  }

  listener {
    lb_port           = 9411
    instance_port     = 30002
    lb_protocol       = "http"
    instance_protocol = "http"
  }
  listener {
    lb_port           = 6443
    instance_port     = 6443
    lb_protocol       = "TCP"
    instance_protocol = "TCP"
  }

}
output "aws_elb" {
  value = "elb security group id , ${aws_security_group.k8s-security-group.id}"
}

output "sock_shop_address_elb" {
  value = "${aws_elb.ci-sockshop-k8s-elb.dns_name}"
}
