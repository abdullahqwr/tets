# Secrets Management Runbook

## Principles
- Secrets never stored in plaintext within the repository.
- GitHub Actions uses OIDC to request scoped tokens from Azure AD.
- Azure Key Vault is the single source of truth for credentials.

## Rotating Secrets
1. Generate new secret value following the relevant policy (password length, certificates, etc.).
2. Use Azure CLI with just-in-time privileged access:
   ```bash
   az keyvault secret set --vault-name <kv-name> --name <secret-name> --value <new-value>
   ```
3. If the secret is consumed by pods via CSI driver, restart the affected deployments to pick up changes:
   ```bash
   kubectl rollout restart deployment/<name> -n <namespace>
   ```
4. Update Terraform variables or GitHub Actions environment variables if necessary (never commit plaintext values).

## Granting Access
- Modify Key Vault access policies through Terraform to maintain auditing.
- For GitHub Actions, add federated credentials in Azure AD referencing the workflow audience and subject claim.

## Incident Response
- In case of suspected compromise, disable the secret by setting an expiration date in Key Vault, rotate immediately, and follow the [rollback](rollback.md) runbook if applications are affected.
