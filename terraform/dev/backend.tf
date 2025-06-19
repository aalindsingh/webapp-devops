terraform {
  backend "s3" {
    bucket       = "flaskapp-infra-state"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
