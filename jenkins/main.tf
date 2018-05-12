variable "SSH_KEY" {}

variable "SECURITY_GROUP_IDS" {
  type = "list"
}

resource "aws_key_pair" "mainkey" {
  key_name   = "main-key"
  public_key = "${var.SSH_KEY}"
}

resource "aws_instance" "Developer-Tools" {
  ami           = "ami-b41377cc"                      //container os comes with docker
  instance_type = "t2.xlarge"
  key_name      = "${aws_key_pair.mainkey.key_name }"

  vpc_security_group_ids = ["${var.SECURITY_GROUP_IDS}"]

  /*this shit is not working
  provisioner "file" {
    source      = "setup-jenkins.sh"
    destination = "./setup-jenkins.sh"

    connection {
      type        = "ssh"
      user        = "core"
      private_key = "${file("~/.ssh/id_rsa")}"
      agent       = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ./setup-jenkins.sh",
      "./setup-jenkins.sh",
    ]
  }*/

  tags {
    Name      = "Developer-Tools"
    Softwares = "Jenkins"
  }
}
