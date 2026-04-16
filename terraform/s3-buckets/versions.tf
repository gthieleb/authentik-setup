terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# NOTE: gthieleb/terraform-aws-s3-easy module doesn't exist yet.
# A local mock module (./modules/s3-easy/) is used for terraform validate.
