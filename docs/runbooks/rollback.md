# Rollback Runbook

## Preconditions
- Incident commander appointed and stakeholders informed.
- Last known good release identified (tag or commit SHA).
- Access to GitHub Actions environments with approval rights.

## Rollback Procedure
1. **Stabilize**
   - Enable maintenance mode banner on the frontend via ConfigMap update if necessary.
   - Scale the impacted deployment to zero replicas to stop traffic if the issue is critical.
2. **Infrastructure Rollback**
   - Re-run the Terraform workflow on the commit associated with the last known good state.
   - Approve the manual gate; Terraform will reconcile infrastructure back to the stable version.
3. **Application Rollback**
   - Trigger the `frontend` and/or `backend` GitHub Actions workflows with the previous tag using workflow dispatch.
   - Provide the image tag override input (e.g., `IMAGE_TAG=v1.4.2`).
   - Confirm the Helm upgrade completed with the previous container image and ConfigMap revisions.
4. **Validate**
   - Execute smoke tests and monitor Grafana dashboards to confirm SLOs are back in range.
   - Review Azure Monitor alerts to ensure they have cleared.
5. **Post-Mortem**
   - Create an incident ticket and attach logs, Prometheus snapshots, and Terraform state diff.
   - Schedule a blameless post-incident review within 48 hours.
