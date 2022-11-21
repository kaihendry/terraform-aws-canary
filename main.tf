locals {
  file_content = { for k, v in var.endpoints :
    k => templatefile("${path.module}/canary-lambda.js.tpl", {
      endpoint = v.url
    })
  }
}

data "archive_file" "canary_archive_file" {
  for_each    = var.endpoints
  type        = "zip"
  output_path = "${path.module}/tmp/${each.key}-${md5(local.file_content[each.key])}.zip"

  source {
    content  = local.file_content[each.key]
    filename = "nodejs/node_modules/index.js"
  }
}

resource "aws_synthetics_canary" "canary" {
  for_each             = var.endpoints
  name                 = each.key
  artifact_s3_location = "s3://${var.s3_artifact_bucket}/${each.key}"
  execution_role_arn   = aws_iam_role.canary_role.arn
  handler              = "index.handler"
  zip_file             = "${path.module}/tmp/${each.key}-${md5(local.file_content[each.key])}.zip"
  runtime_version      = "syn-nodejs-puppeteer-3.8"
  start_canary         = true

  schedule {
    expression = var.schedule_expression
  }

  depends_on = [data.archive_file.canary_archive_file, aws_iam_role_policy_attachment.canary_role_policy]
}
