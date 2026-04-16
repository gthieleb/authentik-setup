# NOTE: This module uses gthieleb/terraform-aws-s3-easy which doesn't exist yet.
# This is a reference implementation showing how the module WOULD be used.
# A local mock module (./modules/s3-easy/) is provided for terraform validate to pass.
#
# IMPORTANT: This module's own Terraform state should be stored SEPARATELY
# (e.g., local backend or a different bucket). Do NOT store it in a bucket
# this module creates — that's a circular dependency.

provider "aws" {
  region = var.aws_region
}

# tfstate bucket — stores Terraform state files
module "tfstate_bucket" {
  source = "./modules/s3-easy" # TODO: Replace with "gthieleb/terraform-aws-s3-easy/aws" when published
  # source  = "gthieleb/terraform-aws-s3-easy/aws"
  # version = "~> 1.0"

  bucket_name   = var.tfstate_bucket_name
  region        = var.aws_region
  versioning    = true
  encryption    = true
  force_destroy = false

  tags = merge(var.common_tags, {
    Purpose = "terraform-state"
  })
}

# CNPG backup bucket — stores CloudNativePG database backups
module "cnpg_backup_bucket" {
  source = "./modules/s3-easy" # TODO: Replace with "gthieleb/terraform-aws-s3-easy/aws" when published
  # source  = "gthieleb/terraform-aws-s3-easy/aws"
  # version = "~> 1.0"

  bucket_name   = var.cnpg_backup_bucket_name
  region        = var.aws_region
  versioning    = true
  encryption    = true
  force_destroy = false

  tags = merge(var.common_tags, {
    Purpose = "cnpg-backup"
  })
}
