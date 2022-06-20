resource "aws_sns_topic" "pipeline_updates" {
  name  = "codepipeline-updates-topic"
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = "${aws_sns_topic.pipeline_updates.arn}"
  protocol  = "email"
  endpoint  = "vanikadali509@gmail.com"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "automation-pipeline"
  role_arn = "${var.role_arn}"

  artifact_store {
    location = "${var.artifact-bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        RepositoryName = var.repo-name
        BranchName  = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["build"]

      configuration = {
        ProjectName = "${aws_codebuild_project.codepipeline_plan_project.name}"
      }
    }
  }


  stage {
    name = "Manual-Approval"


    action {
      name     = "Approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        NotificationArn = "${aws_sns_topic.pipeline_updates.arn}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Apply"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["build"]
      output_artifacts = ["Deploy"]

      configuration = {
        ProjectName = "${aws_codebuild_project.codepipeline_apply_project.name}"
      }
    }
  }

 }
