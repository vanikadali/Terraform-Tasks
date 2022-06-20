output "role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}

output "artifact-bucket-name" {
  value = "${aws_s3_bucket.codepipeline_bucket.bucket}"
}
