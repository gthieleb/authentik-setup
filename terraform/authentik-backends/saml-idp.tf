# Default SAML attribute mappings maintained by authentik.
data "authentik_property_mapping_provider_saml" "default_mappings" {
  managed_list = [
    "goauthentik.io/providers/saml/email",
    "goauthentik.io/providers/saml/groups",
    "goauthentik.io/providers/saml/name",
    "goauthentik.io/providers/saml/upn",
    "goauthentik.io/providers/saml/username",
  ]
}

# SAML provider where authentik acts as the Identity Provider for a service provider.
resource "authentik_provider_saml" "idp" {
  # Human-readable provider name shown in authentik.
  name = local.saml_idp_name

  # Service Provider Assertion Consumer Service endpoint that receives SAML responses.
  acs_url = var.saml_acs_url

  # Entity ID / issuer that the downstream SP should trust for this authentik instance.
  issuer = local.authentik_base_url

  # Built-in authorization flow for user consent/login during SAML sign-on.
  authorization_flow = data.authentik_flow.default-authorization-implicit-consent.id

  # Built-in invalidation flow used during logout/session invalidation.
  invalidation_flow = data.authentik_flow.default-provider-invalidation-flow.id

  # Default SAML attribute mappings exported in assertions for the SP.
  property_mappings = data.authentik_property_mapping_provider_saml.default_mappings.ids
}

# Application object used to expose the SAML IdP provider inside authentik.
resource "authentik_application" "saml_idp" {
  # Human-readable application name shown to admins and users.
  name = local.saml_idp_name

  # Stable slug used by authentik to build SAML SSO/SLO/metadata endpoints.
  slug = local.saml_idp_slug

  # Link the application to the SAML provider above.
  protocol_provider = authentik_provider_saml.idp.id

  # Example SP metadata URL pattern for downstream integrations:
  # ${local.authentik_base_url}/application/saml/${local.saml_idp_slug}/metadata/
}
