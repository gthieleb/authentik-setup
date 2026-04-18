# Authentik Identity Provider Infrastructure

GitOps-managed Authentik deployment via ArgoCD with CNPG PostgreSQL, Traefik IngressRoute, and Terraform modules for identity backend configuration. This repository provides a production-ready blueprint for deploying and managing a self-hosted identity provider.

## Architecture

The infrastructure consists of the following components:
- **Authentik**: The core identity provider and authentication server.
- **CNPG (CloudNativePG)**: Manages the PostgreSQL cluster for Authentik's data storage.
- **Traefik**: Handles ingress traffic via `IngressRoute` CRDs.
- **ArgoCD**: Orchestrates the deployment using a GitOps approach with multi-source ApplicationSets.
- **Terraform**: Configures the Authentik backend (providers, applications, sources) and supporting infrastructure like S3 buckets.

## Repository Structure

```
├── AGENTS.md              — AI agent context
├── README.md              — This file
├── argocd/
│   └── applicationset.yaml — ArgoCD ApplicationSet (multi-source, sync waves)
├── charts/
│   ├── authentik/
│   │   └── values.yaml    — Authentik Helm values (production-sane)
│   └── cnpg/
│       └── values.yaml    — CNPG Cluster Helm values
├── k8s/
│   └── ingressroute.yaml  — Traefik IngressRoute + cert-manager Certificate
└── terraform/
    ├── authentik-backends/ — TF module: OAuth2/OIDC + SAML2 providers
    └── s3-buckets/         — TF module: S3 buckets (dummy example)
```

## Prerequisites

Before deploying, ensure you have the following:
- **Kubernetes cluster**: Version 1.28 or newer.
- **ArgoCD**: Version 2.6 or newer (required for multi-source support).
- **Traefik**: Installed with `IngressRoute` CRDs (`traefik.io/v1alpha1`).
- **cert-manager**: Installed with a `ClusterIssuer` named `letsencrypt-prod`.
- **CNPG operator**: Installed in the cluster (e.g., via the `cloudnative-pg/cloudnative-pg` Helm chart).
- **Helm repositories**: Added to ArgoCD:
  - `argocd repo add https://charts.goauthentik.io`
  - `argocd repo add https://cloudnative-pg.github.io/charts/`
- **AWS credentials**: Configured for the S3 bucket Terraform module.
- **Terraform**: Version 1.5 or newer.

## Quick Start

1. **Clone this repository**:
   ```bash
   git clone https://github.com/gthieleb/authentik-setup.git
   cd authentik-setup
   ```

2. **Configure your domain**:
   Replace `authentik.example.com` with your actual domain in the following files:
   - `charts/authentik/values.yaml`
   - `k8s/ingressroute.yaml`
   - `argocd/applicationset.yaml`
   - `terraform/authentik-backends/terraform.tfvars.example`

3. **Create Kubernetes secrets**:
   - `authentik-cnpg-app` in the `database` namespace (CNPG creates this automatically once the cluster is initialized).
   - `cnpg-s3-creds` in the `database` namespace for S3 backups:
     ```bash
     kubectl create secret generic cnpg-s3-creds \
       --namespace database \
       --from-literal=ACCESS_KEY_ID=<your-key> \
       --from-literal=ACCESS_SECRET_KEY=<your-secret>
     ```
   - **Authentik secret key**: Set this via Helm values or a Kubernetes secret.

4. **Apply the ApplicationSet**:
   ```bash
   kubectl apply -f argocd/applicationset.yaml
   ```

5. **Wait for deployment**:
   - **Wave -1**: Wait for the CNPG cluster to be ready.
   - **Wave 0**: Wait for Authentik to become healthy.
   - **Wave 1**: Wait for the IngressRoute to be applied.

6. **Bootstrap Terraform**:
   Obtain your initial bootstrap token from the Authentik logs or UI and export it:
   ```bash
   export AUTHENTIK_BOOTSTRAP_TOKEN=<your-token>
   ```

7. **Configure backends**:
   ```bash
   cd terraform/authentik-backends
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your specific configuration
   terraform init
   terraform apply
   ```

## Configuration

- **`argocd/applicationset.yaml`**: Defines the deployment lifecycle and sync waves.
- **`charts/authentik/values.yaml`**: Production-ready Helm values for Authentik, including HPA and PDB settings.
- **`charts/cnpg/values.yaml`**: Configuration for the PostgreSQL cluster, including backup settings to S3.
- **`k8s/ingressroute.yaml`**: Traefik routing and TLS certificate request via cert-manager.
- **`terraform/authentik-backends/device-flow.tf`**: Device Authorization Flow (RFC 8628) configuration — a flow with `designation="stage_configuration"` for headless/CLI clients. Configure via `authentik_brand_domain` variable (use `"."` for the default brand) to assign it to a brand via `flow_device_code`. Outputs: `device_flow_slug` and `device_authorization_endpoint` (`/application/o/device/`).

## Terraform Modules

- **`authentik-backends`**: Manages OAuth2/OIDC providers, SAML2 Identity Providers, Service Provider configurations, and OAuth2 Device Authorization Flow (RFC 8628) for headless/CLI authentication.
- **`s3-buckets`**: A dummy example demonstrating S3 bucket creation using a local mock of the `gthieleb/terraform-aws-s3-easy` module.

## Customization

To add new identity providers or applications:
1. **OAuth2/OIDC**: Add new `authentik_provider_oauth2` and `authentik_application` resources in the `terraform/authentik-backends` module.
2. **SAML**: Configure new SAML sources or IdPs by adding the corresponding resources in the Terraform module.
3. **Helm Values**: Adjust `charts/authentik/values.yaml` to tune performance, resource limits, or enable additional Authentik features.
4. **Device Flow (RFC 8628)**: Customize the flow slug or authentication requirements in `device-flow.tf`. The flow is enabled by assigning it to a brand via the `flow_device_code` field using the `authentik_brand_domain` variable.

## License

Apache 2.0
