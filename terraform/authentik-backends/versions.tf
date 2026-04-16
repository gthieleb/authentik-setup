terraform {
  required_version = ">= 1.5"

  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "~> 2025.12"
    }
  }
}
