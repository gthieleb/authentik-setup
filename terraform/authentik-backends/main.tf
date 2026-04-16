# Authentik provider configuration
# Bootstrapping: Use AUTHENTIK_BOOTSTRAP_TOKEN env var for initial setup.
# After initial setup, create a service account token via authentik_token resource
# and use that for ongoing automation.
provider "authentik" {
  url   = var.authentik_url
  token = var.authentik_token
}

# Built-in flow data sources (DO NOT create custom flows)
data "authentik_flow" "default-authorization-implicit-consent" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "default-provider-invalidation-flow" {
  slug = "default-provider-invalidation-flow"
}

data "authentik_flow" "default-authentication-flow" {
  slug = "default-authentication-flow"
}

data "authentik_flow" "default-enrollment-flow" {
  slug = "default-enrollment-flow"
}

data "authentik_flow" "default-source-authentication" {
  slug = "default-source-authentication"
}

data "authentik_flow" "default-source-enrollment" {
  slug = "default-source-enrollment"
}

data "authentik_flow" "default-source-pre-authentication" {
  slug = "default-source-pre-authentication"
}

locals {
  authentik_base_url      = trimsuffix(var.authentik_url, "/")
  oauth2_application_name = "Example OAuth2 Application"
  oauth2_application_slug = "example-oauth2-app"
  saml_idp_name           = "Example SAML Service Provider"
  saml_idp_slug           = "example-saml-sp"
  saml_source_name        = "Example External SAML IdP"
  saml_source_slug        = "example-saml-idp"
}
