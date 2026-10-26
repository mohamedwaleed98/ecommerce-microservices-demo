# Cloud diff — AWS vs Azure vs GCP

Running log of what differs across the three clouds for the same workload. The most credible
artifact in this repo for the multi-cloud claim, and the answer to "which cloud would you pick
and why".

**Fill rows in as you hit them on AWS — not at the end.** By the time you reach Stage 12 you
will have forgotten the AWS details, and a table written from documentation instead of from
experience reads exactly like one.

For each row: not just *what* the equivalent service is, but what's genuinely different about
using it — the thing you'd only know from having done it.

| Dimension | AWS (EKS) | Azure (AKS) | GCP (GKE) |
|---|---|---|---|
| Control plane cost | ~$73/mo | free | free zonal tier |
| Cluster IaC | | | |
| Node provisioning | | | |
| Workload identity | | | |
| Container registry | | | |
| Secret injection | | | |
| Ingress / L7 | | | |
| TLS certificates | | | |
| DNS automation | | | |
| Managed MySQL | | | |
| DB connectivity from pods | | | |
| Pod networking / CNI | | | |
| Pod IP limits | | | |
| CSI / storage classes | | | |
| Metrics (managed option) | | | |
| Logs (managed option) | | | |
| Cluster upgrade process | | | |
| Node OS / patching | | | |
| Audit logging | | | |
| CI/CD native option | | | |
| Cost visibility & tagging | | | |
| Biggest surprise | | | |

## Notes per cloud

### AWS

### Azure

### GCP

## If I had to pick one

(Write this last. It's the question, and the answer should be "it depends on X, Y, Z" with
X, Y and Z named from the table above — not from a vendor comparison page.)
