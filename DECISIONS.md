# Decisions

One entry per architectural choice. Gate 5 of every curriculum topic.

The point is not the decision — it's being able to say, out loud, what you rejected and why.
That is the difference between "I used Karpenter" and "I chose Karpenter over Cluster
Autoscaler because…", and it is the single most senior-sounding thing in an interview.

## Format

```
## NNN — <Decision in one line>
Date: YYYY-MM-DD · Topic: <curriculum topic>

**Context** — what forced a choice. One or two sentences.
**Options** — what was on the table, including the one that looked obvious.
**Decision** — what I picked.
**Why** — the reasoning, in my own words.
**Rejected because** — the strongest argument against my choice, and why I accepted it anyway.
**Revisit if** — what would change my mind.
```

Keep each under 150 words. If it needs more, the decision isn't clear yet.

---

## 000 — Example: the format, using a decision already made in this repo
Date: 2026-10-26 · Topic: (pre-curriculum)

**Context** — EKS worker nodes need to be provisioned, and the cluster is torn down nightly
for cost reasons.

**Options** — on-demand managed node group · spot managed node group · Karpenter · Fargate.

**Decision** — one small on-demand group for system pods, one spot group for app pods.

**Why** — spot is ~70% cheaper and this cluster is disposable, so an interruption costs
nothing real. Keeping system pods on-demand means CoreDNS and the ALB controller don't get
evicted mid-lesson.

**Rejected because** — Karpenter is the modern answer and would have been the better learning
target. Accepted anyway: node groups are simpler to reason about while learning everything
else, and Karpenter is a scheduled curriculum topic in Stage 7 where it gets proper attention.

**Revisit if** — Stage 7 lands, or spot interruptions start disrupting sessions.

---
