resource "aws_instance" "ci-sockshop-k8s-master" {
  instance_type   = var.node_instance_type
  ami             = lookup(var.aws_amis, var.aws_region)
  key_name        = var.key_name
  security_groups = ["${aws_security_group.k8s-security-group.name}"]
  tags = {
    Name = "ci-sockshop-k8s-master"
  }
  user_data = file("${path.module}/start.sh")

  provisioner "file" {
    source      = "${path.module}/../Complete_parts"
    destination = "/tmp/"
  }
  provisioner "file" {
    source      = "${path.module}/../complete-demo.yaml"
    destination = "/tmp/complete-demo.yaml"
  }
  provisioner "file" {
    source      = "${path.module}/config_kubernets_master.sh"
    destination = "/tmp/master_setup.sh"
  }
  provisioner "file" {
    source      = "${path.module}/deployment.sh"
    destination = "/tmp/deploy_sockshop.sh"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${var.private_key_path}")
    host        = self.public_ip
  }


  /*  provisioner "local-exec" {
    command = "sudo ssh -i ${var.private_key_path} -o StrictHostKeyChecking=no ubuntu@${self.public_ip} 'sudo kubeadm init --ignore-preflight-errors=all > k8s-init.log'"   
  }
  provisioner "local-exec" {
    command ="tail -n 2 k8-init.log > joiningToken.txt"

  }
  provisioner "local-exec" {
    command ="sudo ssh -i ${var.private_key_path} -o StrictHostKeyChecking=no ubuntu@${self.public_ip} 'kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml'"
  }
 */
}
output "master" {
  value = "master id is ,${aws_instance.ci-sockshop-k8s-master.id}"
}
output "masterIP" {
  value = "master ip is ,${aws_instance.ci-sockshop-k8s-master.public_ip}"
}