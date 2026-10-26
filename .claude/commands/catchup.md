---
description: Re-orient after a break; reconcile claimed state with actual state
---

Read `CLAUDE.md` and `docs/curriculum.md`, then inspect the repo: `git log --oneline -20`,
`terraform/`, `deploy/k8s/`, `deploy/argocd/`, `scripts/`, `.github/workflows/`.

Tell me:

1. **What's actually built right now**, from the evidence in the repo — not from what the
   curriculum claims.
2. **Where the curriculum's ticks disagree with reality.** Ticked topics whose code isn't
   there, or finished work that was never ticked.
3. **Anything created outside Terraform state** that a `destroy`/`apply` cycle would silently
   break. Check `scripts/` especially.
4. **Anything that would bill while I wasn't looking** — orphaned ALBs, EIPs, NAT gateways,
   snapshots, EBS volumes. Tell me the CLI command to check rather than guessing.
5. **The single highest-value next topic**, and why it's that one rather than the next
   unticked box.

Then update `docs/curriculum.md` so the ticks match reality. Change nothing else.
