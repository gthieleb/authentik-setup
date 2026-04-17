# OAuth2 Device Authorization Grant flow (RFC 8628)
#
# Enables headless/CLI authentication where the user verifies on a
# separate device (phone, browser) by visiting the verification URL
# and entering a short user_code.
#
# Endpoint:   POST /application/o/device/
# Token:      POST /application/o/token/
#             grant_type=urn:ietf:params:oauth:grant-type:device_code
#
# This flow coexists with the authorization-code flow — the client
# decides which grant type to use by the endpoint it calls.

resource "authentik_flow" "device_code" {
  name           = "Device code flow"
  title          = "Device code flow"
  slug           = "default-device-code-flow"
  designation    = "stage_configuration"
  authentication = "require_authenticated"
}
