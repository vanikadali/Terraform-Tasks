data "template_file" "buildspec-plan" {
  template = file("buildspec-plan.yml")

}


data "template_file" "buildspec-apply" {
  template = file("buildspec-apply.yml")

}





resource "aws_codebuild_project" "codepipeline_plan_project" {
  name          = "codepipeline-plan-project"
  description   = "$codebuild_project"
  build_timeout = "5"
  service_role  = "${var.role_arn}"

  artifacts {
    type           = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

  }
  source {
    buildspec           = data.template_file.buildspec-plan.rendered
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }

}

resource "aws_codebuild_project" "codepipeline_apply_project" {
  name          = "code-pipeline-apply-project"
  description   = "codebuild_project"
  build_timeout = "5"
  service_role  = "${var.role_arn}"

  artifacts {
    type           = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

  }

  source {
    type      = "CODEPIPELINE"
    buildspec           = data.template_file.buildspec-apply.rendered
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false

  }

