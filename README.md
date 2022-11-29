<img src="https://s.natalian.org/2022-11-21/canary.png" alt="Synthetics Canaries">

# Goal

Check service is up, check connectivity between canary and endpoint.

A helpful application of https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary

# Usage example

    module "canaries" {
      source = "github.com/kaihendry/terraform-canary"
      schedule_expression = "rate(5 minutes)"
      s3_artifact_bucket  = "my-bucket-of-artifacts" # must pre-exist
      alarm_email         = "alarm@example.com" # you need to confirm this email address
      endpoints           = { "example" = { url = "https://example.com" }, "google" = { url = "https://google.com" } }
    }
