# Agent Context

Repository purpose: GitOps-managed Authentik identity provider deployment with CNPG, Traefik, ArgoCD, and Terraform.

## Directory Map
- `argocd/` — ArgoCD ApplicationSet with multi-source pattern and sync waves.
- `charts/authentik/` — Authentik Helm chart values (production-sane, CNPG integration).
- `charts/cnpg/` — CloudNativePG Cluster Helm values (S3 backup, PodMonitor).
- `k8s/` — Traefik IngressRoute + cert-manager Certificate manifests.
- `terraform/authentik-backends/` — OAuth2/OIDC + SAML2 provider/source configuration.
- `terraform/s3-buckets/` — S3 bucket provisioning (dummy module for `gthieleb/terraform-aws-s3-easy`).

## Key Files
- `argocd/applicationset.yaml` — top-level ArgoCD deployment orchestration.
- `charts/authentik/values.yaml` — Authentik runtime settings and DB wiring.
- `charts/cnpg/values.yaml` — PostgreSQL cluster, backups, and monitoring.
- `k8s/ingressroute.yaml` — public routing via Traefik.
- `terraform/authentik-backends/*.tf` — IdP backend/provider definitions.
- `terraform/s3-buckets/*.tf` — bucket resources for backups and artifacts.

## Tech Stack
- Authentik 2026.2.x
- CloudNativePG (CNPG)
- Traefik IngressRoute CRD
- ArgoCD multi-source Applications
- Terraform: authentik provider `~> 2025.12`, AWS `~> 5.0`
- cert-manager

## Conventions
- Domain placeholder: `authentik.example.com`
- Namespaces: `authentik` (app), `database` (CNPG), `argocd` (ArgoCD)
- Sync waves: `-1` (CNPG) → `0` (Authentik) → `1` (IngressRoute)
- Secret pattern: `file:///` for CNPG credentials

## Common Operations
- Validate YAML: `python3 -c "import yaml; yaml.safe_load(open('file'))"`
- Validate Terraform: `cd terraform/<module> && terraform init -backend=false && terraform validate`
- Secret scan: `grep -riE '(password|secret_key|token).*=\s*["\x27][a-zA-Z0-9]{8,}["\x27]' --include='*.tf' --include='*.yaml' .`
