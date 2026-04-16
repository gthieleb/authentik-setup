# SAML source where authentik acts as the Service Provider / consumer for an external IdP.
resource "authentik_source_saml" "source" {
  # Human-readable source name shown in authentik.
  name = local.saml_source_name

  # Stable source slug used in authentik URLs and metadata.
  slug = local.saml_source_slug

  # External Identity Provider SSO endpoint that authentik redirects users to.
  sso_url = var.saml_source_sso_url

  # Built-in pre-authentication flow that runs before sending users to the external IdP.
  pre_authentication_flow = data.authentik_flow.default-source-pre-authentication.id

  # Built-in authentication flow that finalizes the login after the SAML response returns.
  authentication_flow = data.authentik_flow.default-source-authentication.id

  # Built-in enrollment flow used when new users are created from SAML assertions.
  enrollment_flow = data.authentik_flow.default-source-enrollment.id

  # Configure the external IdP metadata/certificates in authentik when onboarding a real IdP.
}
