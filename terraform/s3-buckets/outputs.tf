output "tfstate_bucket_arn" {
  value = module.tfstate_bucket.bucket_arn
}

output "tfstate_bucket_name" {
  value = module.tfstate_bucket.bucket_name
}

output "cnpg_backup_bucket_arn" {
  value = module.cnpg_backup_bucket.bucket_arn
}

output "cnpg_backup_bucket_name" {
  value = module.cnpg_backup_bucket.bucket_name
}
