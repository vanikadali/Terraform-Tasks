provider "aws" {
  region  = "us-east-1"

}

module "pre-required" {
  source   = "./modules/pre-requesties"
}

module "codepipeline" {
  source   = "./modules/"
  artifact-bucket = module.pre-required.artifact-bucket-name
  role_arn        = module.pre-required.role_arn
 repo-name = "my-first-repository"
depends_on = [ module.pre-required ]

}
