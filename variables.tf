variable "s3_artifact_bucket" {
  type        = string
  description = "Location in Amazon S3 where Synthetics stores artifacts from the test runs of this canary"
}

variable "schedule_expression" {
  type        = string
  description = "Expression defining how often the canary runs"
}

variable "endpoints" {
  type = map(object({
    url = string
  }))
}

variable "alarm_email" {
  type        = string
  description = "Email address to send alarms to"
}
