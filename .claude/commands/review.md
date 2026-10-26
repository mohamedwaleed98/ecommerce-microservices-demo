---
description: Senior-engineer critique of code I wrote myself
---

`review` mode. Read `CLAUDE.md` first. I wrote the code below myself — do NOT rewrite it.

Review it like a senior platform engineer, in this order:

1. **Correctness** — does it do what it claims? Name the specific input or state that breaks it.
2. **Works today, breaks in six months** — unpinned versions, deprecated APIs, hard-coded
   account IDs or AZs, things that only work because of state created by hand.
3. **Outside Terraform state** — anything created imperatively that a `destroy`/`apply` cycle
   would silently fail to restore. This repo already has this problem in
   `scripts/bootstrap-cluster.sh`; don't let it spread.
4. **Interview exposure** — what would a sharp interviewer poke at here, and what's my answer?
5. **Cost** — anything that bills hourly, with a monthly estimate.

Rank findings by severity. Say plainly when something is fine — don't invent problems to look
thorough. For each finding: what to change and *why*, not the replacement code. I type it.

$ARGUMENTS
