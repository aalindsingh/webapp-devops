provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "flaskapp_infra_state" {
  bucket        = "flaskapp-infra-state"
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "TerraformState"
    Environment = "Dev"
  }
}
