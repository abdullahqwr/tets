# Deployment Runbook

## Purpose
Ensure safe and repeatable deployments of infrastructure and application code using GitHub Actions automation.

## Preconditions
- All changes merged to `main`.
- Required GitHub environments (`production`) configured with approval gates.
- Azure federated credentials configured for GitHub Actions.

## Steps
1. **Infrastructure**
   - Merge the Terraform pull request once the automated plan is approved.
   - Navigate to the GitHub Actions *Terraform Apply* workflow run on `main`.
   - Provide the required manual approval from an authorized operator.
   - Monitor the logs to confirm `terraform apply` succeeds without drift.
2. **Applications**
   - For the frontend and backend repositories, verify the `main` branch workflows have completed successfully up to the *Deploy to staging* job.
   - Provide the required approval for the GitHub Actions `staging` environment. Monitor the Helm release in the `frontend-staging` and `backend-staging` namespaces and run smoke checks.
   - Approve the `production` environment once staging validation passes. Ensure the pipelines reuse the same image tag when promoting.
   - Confirm container images are tagged with the Git commit SHA, pushed to ACR, and that AKS deployments completed rolling updates (Kubernetes events show `Rolling update complete`).
3. **Post-Deployment Verification**
   - Check Grafana dashboards for error rates and latency.
   - Run smoke tests against the API and frontend via the Application Gateway HTTPS endpoint.
   - Review Azure SQL metrics to ensure connections are stable.
   - Validate PodDisruptionBudgets are healthy with `kubectl get pdb -A` so voluntary disruptions will not reduce replicas below two.

## Rollback Trigger
Follow the [rollback runbook](rollback.md) if SLOs are violated or critical issues are detected.
