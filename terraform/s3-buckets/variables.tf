variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "tfstate_bucket_name" {
  type        = string
  description = "Name for the Terraform state S3 bucket"
}

variable "cnpg_backup_bucket_name" {
  type        = string
  description = "Name for the CNPG backup S3 bucket"
}

variable "common_tags" {
  type = map(string)
  default = {
    Project = "authentik-setup"
  }
}
