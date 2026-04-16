# OAuth2/OIDC provider that authentik exposes to a downstream application.
resource "authentik_provider_oauth2" "oauth2" {
  # Human-readable provider name shown in authentik.
  name = local.oauth2_application_name

  # Stable OAuth2 client identifier presented to the relying application.
  client_id = local.oauth2_application_slug

  # Confidential clients keep credentials server-side and can use a client secret.
  client_type = "confidential"

  # Built-in consent flow used when users authorize the application.
  authorization_flow = data.authentik_flow.default-authorization-implicit-consent.id

  # Built-in logout/invalidation flow used when tokens or sessions are revoked.
  invalidation_flow = data.authentik_flow.default-provider-invalidation-flow.id

  # Allowed callback URLs for the OAuth2/OIDC application.
  allowed_redirect_uris = [
    for uri in var.oauth2_redirect_uris : {
      matching_mode = "strict"
      url           = uri
    }
  ]
}

# Application object that makes the OAuth2/OIDC provider visible in authentik.
resource "authentik_application" "oauth2" {
  # Human-readable application name shown to administrators and end users.
  name = local.oauth2_application_name

  # Stable application slug used in authentik URLs and references.
  slug = local.oauth2_application_slug

  # Link the application to the OAuth2/OIDC protocol provider above.
  protocol_provider = authentik_provider_oauth2.oauth2.id
}
