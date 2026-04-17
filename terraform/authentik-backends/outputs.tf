output "oauth2_client_id" {
  description = "Client ID for the OAuth2/OIDC provider configured in authentik."
  value       = authentik_provider_oauth2.oauth2.client_id
}

output "oauth2_application_slug" {
  description = "Application slug for the OAuth2/OIDC application in authentik."
  value       = authentik_application.oauth2.slug
}

output "saml_idp_metadata_url" {
  description = "Metadata URL that a downstream SAML service provider can import from authentik."
  value       = "${local.authentik_base_url}/application/saml/${authentik_application.saml_idp.slug}/metadata/"
}

output "saml_source_slug" {
  description = "Slug for the external SAML source configured in authentik."
  value       = authentik_source_saml.source.slug
}

output "example_app_url" {
  description = "Example callback URL representing the downstream application integration."
  value       = var.oauth2_redirect_uris[0]
}

output "device_flow_slug" {
  description = "Slug of the device code flow."
  value       = authentik_flow.device_code.slug
}

output "device_authorization_endpoint" {
  description = "Device authorization endpoint for OAuth2 device flow (POST /application/o/device/)."
  value       = "${local.authentik_base_url}/application/o/device/"
}
