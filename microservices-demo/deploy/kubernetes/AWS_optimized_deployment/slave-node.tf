resource "aws_instance" "ci-sockshop-k8s-node" {
  instance_type   = var.node_instance_type
  count           = var.node_count
  ami             = lookup(var.aws_amis, var.aws_region)
  key_name        = var.key_name
  security_groups = ["${aws_security_group.k8s-security-group.name}"]
  tags = {
    Name = "node-ci-sockshop-k8s"
  }
  user_data = file("${path.module}/start.sh")
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${var.private_key_path}")
    host        = self.public_ip
  }

}
/* output "node" {
  value = "node information is ,${aws_instance.ci-sockshop-k8s-node.id}"
} */

output "node_addresses" {
  value = ["${aws_instance.ci-sockshop-k8s-node.*.public_dns}"]
}