provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "first-vpc" {
  cidr_block = "10.0.0.0/16"

  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name    = "First_VPC",
    service = "production"
  }
}



resource "aws_vpc" "second-vpc" {
  cidr_block = "10.1.0.0/16"

  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name    = "Second_VPC",
    service = "production"
  }
}

module "hosted-zone-module" {

  source             = "./modules/"
  domain_name_hosted = var.custom-domain-name
  depends_on         = [aws_vpc.first-vpc]
}


data "aws_vpc" "targetVpc_1" {

  filter {
    name   = "tag:Name"
    values = ["First_VPC"]
  }
  depends_on = [aws_vpc.first-vpc]
}



data "aws_route53_zone" "selected" {
  name         = var.custom-domain-name
  private_zone = true
  vpc_id       = data.aws_vpc.targetVpc_1.id
  depends_on   = [module.hosted-zone-module]
}

resource "aws_route53_zone_association" "second-association" {

  zone_id = data.aws_route53_zone.selected.zone_id
  vpc_id  = aws_vpc.second-vpc.id

}

resource "null_resource" "hostedscript" {


  provisioner "local-exec" {


    command = "aws route53 disassociate-vpc-from-hosted-zone --hosted-zone-id $HZ_ID --vpc VPCRegion=us-east-1,VPCId=$VP_ID && aws ec2 delete-vpc --vpc-id $VP_ID --region us-east-1"

    environment = {
      HZ_ID = data.aws_route53_zone.selected.zone_id
      VP_ID = data.aws_vpc.targetVpc_1.id


    }

  }
  depends_on = [aws_route53_zone_association.second-association]

}
