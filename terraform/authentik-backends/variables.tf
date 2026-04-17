variable "authentik_url" {
  description = "Base URL for the authentik instance."
  type        = string
  default     = "https://authentik.example.com"
}

variable "authentik_token" {
  description = "API token used by Terraform to manage authentik resources."
  type        = string
  sensitive   = true
}

variable "oauth2_redirect_uris" {
  description = "Allowed OAuth2/OIDC redirect URIs for the example application."
  type        = list(string)
  default     = ["https://app.example.com/oauth/callback"]
}

variable "saml_acs_url" {
  description = "Assertion Consumer Service URL exposed by the downstream SAML service provider."
  type        = string
  default     = "https://app.example.com/saml/acs"
}

variable "saml_source_sso_url" {
  description = "Single Sign-On URL exposed by the upstream external SAML Identity Provider."
  type        = string
  default     = "https://idp.example.com/saml/sso"
}

variable "authentik_brand_domain" {
  description = "Domain of the Authentik brand to configure. Use the authentik instance domain or '.' for the default brand."
  type        = string
  default     = "authentik.example.com"
}
