# Scaling Runbook

## Objectives
Maintain performance targets (≥300 RPS, p95 latency ≤300 ms) by adjusting Kubernetes scaling parameters.

## Horizontal Scaling (Pods)
1. Review Prometheus dashboards for CPU, memory, and request metrics.
2. Adjust HorizontalPodAutoscaler (HPA) targets via `kubectl edit hpa <service>` or updating Helm values.
3. Verify updates propagate:
   ```bash
   kubectl get hpa -n <namespace>
   ```
4. Monitor for 15 minutes to ensure pods stabilize and SLOs recover.

## Vertical Scaling (Nodes)
1. Confirm sustained HPA saturation or pod pending events via Grafana and `kubectl get events`.
2. Update AKS node pool settings in Terraform (`user_node_pool_vm_size`, `max_count`) and create a PR.
3. Run Terraform plan, review, and merge after approval; pipeline will apply changes automatically.
4. Validate `kubectl get nodes` shows new capacity and pods are scheduled.

## Database Scaling
1. Review Azure SQL DTU/CPU metrics in Azure Monitor.
2. Update `sql_sku_name` via Terraform for higher tier; submit PR and follow standard deployment runbook.
3. Confirm application connection resiliency using retry metrics and logs.

## Application Gateway / Ingress
- If TLS termination or WAF is bottlenecked, adjust Application Gateway SKU and autoscaling min/max in Azure Portal or via Terraform variables, then redeploy.
