terraform {
  required_version = ">= 0.11.6"

  backend "s3" {
    bucket = "analyze-football-devops"
    key    = "infrastructure.tfstate"
    region = "us-west-2"
  }
}

/**
 * defining variables to be used everywhere. The values will come from external
 * secrets file, that is not committed in repository
 */
variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}

variable "SSH_KEY" {}

/**
 * Using Amazon aws as provider
 */
provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}" //accessing the defined variable
  secret_key = "${var.AWS_SECRET_KEY}" //accessing the defined variable
  region     = "us-west-2"
}

variable "environment_name" {
  description = "The name of the vpc environment"
  default     = "Main"
}

resource "aws_default_vpc" "main" {
  tags = {
    Name        = "${var.environment_name}-vpc"
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

resource "aws_default_security_group" "default-security" {
  vpc_id = "${aws_default_vpc.main.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment_name}-default-security-group"
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

resource "aws_security_group" "Allow-SSH" {
  name        = "SSH"
  description = "Allow all ssh traffic"
  vpc_id      = "${aws_default_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment_name}-ssh-security-group"
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

resource "aws_security_group" "Allow-HTTP" {
  name        = "HTTP"
  description = "Allow all HTTP traffic"
  vpc_id      = "${aws_default_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment_name}-http-security-group"
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

resource "aws_security_group" "Allow-HTTPS" {
  name        = "HTTPS"
  description = "Allow all HTTPS traffic"
  vpc_id      = "${aws_default_vpc.main.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment_name}-https-security-group"
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

resource "aws_security_group" "Allow-HTTP8080" {
  name        = "HTTP8080"
  description = "Allow all HTTPS traffic"
  vpc_id      = "${aws_default_vpc.main.id}"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment_name}-https-security-group"
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

module "jenkins" {
  source  = "./jenkins"
  SSH_KEY = "${var.SSH_KEY}"

  SECURITY_GROUP_IDS = ["${aws_default_security_group.default-security.id}",
    "${aws_security_group.Allow-SSH.id}",
    "${aws_security_group.Allow-HTTP8080.id}",
  ]
}
