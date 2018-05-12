variable "SSH_KEY" {}

resource "aws_key_pair" "mainkey" {
  key_name   = "main-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMkArEUYPZv9EjBa2k1DpyGqXikC9+niy5PrHzdfuUAYdzj/wI8i9JDSge4W4rCit5xVXe16a969Lc9Ayh2nRs8p+ZZlRr4ZFgq+qf6qHi4n/Ngpyh4Pg/Tez/WNScQia+A3JEkBagQkNQ5n4Wh8jzCn+DAtqAiXwsatrTPut/L6CXlPFQF88kY+uFJw6wUetoUO2j0evFgp8iDmEJP6F2tb3jQgaSWTmzz7GPskquWYfyFI2xkqsB2p6TFcuhXZ8gL4qM3rmFyvPQg5/czs2CzFzTvNDGcJMePu+ZINLneEYverqcQItzyinBru7UpP8XP4ckIyYTosKYprVr6HX+14d4NUl2ClLrAD+U2ZpqatTg8Ld78bnxuWyf08gNexMx7nrJtMXuKpL6yyq76LRLmfQcBDWIlbyPC8A8vqu6o0exu7963Epg4yBUIiuxx8E1WbnqcasdmSc6HuADx+dmqbt5OSjbsEtI1Xr10GTM1eOIPyVAdFeEKUeClf8d0Ugi9XiHaGf5XukhL0Rp1DDVL0VgmYc/A6eE8ZF9Cw0YNzQ/YCWKbZIdlApw2y0XFPQj6vmvHolGlwLW1jkRonAXZ1sw+F2a01ZgZYBlTDiTxpvxjdzcFMDnTpZgJ3HR04MtWv8Rg50QVuI3/sMcCFOMg65pvVCIhcI0d5eXVxrM7w== hmushtaq@gmail.com"
}

resource "aws_instance" "Developer-Tools" {
  ami           = "ami-b41377cc"                      //container os comes with docker
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.mainkey.key_name }"

  /*
      provisioner "file" {
        source      = "setup-jenkins.sh"
        destination = "~/setup-jenkins.sh"
      }

      provisioner "remote-exec" {
        inline = [
          "./setup-jenkins.sh",
        ]
      }
    */
  tags {
    Name      = "Developer-Tools"
    Softwares = "Jenkins"
  }
}
