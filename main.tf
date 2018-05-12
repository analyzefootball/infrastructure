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

module "vpc-setup" {
  source                           = "terraform-aws-modules/vpc/aws"
  create_vpc                       = false
  manage_default_vpc               = true
  default_vpc_enable_dns_hostnames = true
  default_vpc_name                 = "${var.environment_name}-VPC"

  tags = {
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

resource "aws_default_vpc_dhcp_options" "default" {
  tags {
    Name = "Global DHCP Option Set"
  }
}

resource "aws_default_security_group" "default-security" {
  vpc_id = "${module.vpc-setup.default_vpc_id}"

  tags {
    Name        = "${var.environment_name}-default-security-group"
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

resource "aws_default_route_table" "default-route-table" {
  default_route_table_id = "${module.vpc-setup.main_route_table_id }"

  tags {
    Name        = "${var.environment_name}-default-route-table"
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

resource "aws_default_subnet" "west1" {
  availability_zone = "us-west-2a"

  tags {
    Name        = "${var.environment_name}-west-2a"
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

resource "aws_default_subnet" "west2" {
  availability_zone = "us-west-2b"

  tags {
    Name        = "${var.environment_name}-west-2b"
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

resource "aws_default_subnet" "west3" {
  availability_zone = "us-west-2c"

  tags {
    Name        = "${var.environment_name}-west-2c"
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}

resource "aws_default_network_acl" "default-acl" {
  default_network_acl_id = "${module.vpc-setup.default_vpc_default_network_acl_id}"

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name        = "${var.environment_name}-acl"
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }
}
