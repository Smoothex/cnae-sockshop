resource "aws_instance" "ci-sockshop-k8s-master" {
  instance_type   = "${var.node_instance_type}"
  # count           = "${var.node_count}"
  ami             = "${lookup(var.aws_amis, var.aws_region)}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.k8s-security-group.name}"]
  tags ={
    Name = "ci-sockshop-k8s-master"
  }
user_data = file("${path.module}/start.sh")

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("${var.private_key_path}")}"
    host = "${self.public_ip}"
  }
  /*  provisioner "remote-exec" {
    inline = [
      "scp -i ${var.private_key_path} -o StrictHostKeyChecking=no -rp deploy/kubernetes/complete-demo.yaml ubuntu@${var.master_ip}:/tmp/complete-demo.yaml"
    ]
  } */

}
output "master" {
  value = "master id is ,${aws_instance.ci-sockshop-k8s-master.id}"
}
output "masterIP" {
  value = "master ip is ,${aws_instance.ci-sockshop-k8s-master.public_ip}"
}