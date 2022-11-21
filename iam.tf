data "template_file" "canarypolicy" {
  template = file("${path.module}/canary-policy.json.tpl")
  vars = {
    bucket = var.s3_artifact_bucket
  }
}

resource "aws_iam_policy" "canary_policy" {
  name        = "canary-policy"
  description = "Policy for canary"
  policy      = data.template_file.canarypolicy.rendered
}

resource "aws_iam_role" "canary_role" {
  name               = "CloudWatchSyntheticsRole"
  assume_role_policy = data.aws_iam_policy_document.canary_assume_role.json
}

data "aws_iam_policy_document" "canary_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "canary_role_policy" {
  role       = aws_iam_role.canary_role.name
  policy_arn = aws_iam_policy.canary_policy.arn
}
