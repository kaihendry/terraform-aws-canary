resource "aws_cloudwatch_metric_alarm" "canary_alarm" {
  for_each = var.endpoints

  alarm_name          = "${each.key}-canary-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Failed"
  namespace           = "CloudWatchSynthetics"
  period              = "60" # 1 minute
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"

  dimensions = {
    CanaryName = aws_synthetics_canary.canary[each.key].name
  }

  alarm_description = "Canary alarm for ${each.key}"

  alarm_actions = [
    aws_sns_topic.canary_alarm.arn
  ]
}

# create SNS topic for canary alarm
resource "aws_sns_topic" "canary_alarm" {
  name              = "canary-alarm"
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_subscription" "canary_alarm" {
  topic_arn = aws_sns_topic.canary_alarm.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}
