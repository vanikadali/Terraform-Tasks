data "aws_vpc" "targetVpc" {

  filter {
    name   = "tag:Name"
    values = ["First_VPC"]
  }

}
resource "aws_route53_zone" "mydomain" {
  name = var.domain_name_hosted
  vpc {
    vpc_id = data.aws_vpc.targetVpc.id
  }
}
