# Curriculum

Single source of truth for what I'm learning, where I am, and what's built.
Claude reads this at the start of every session and works the **first unticked topic**.

## How a topic gets ticked

Five gates, all of them, checked by Claude and not by me:

| Gate | Means |
|---|---|
| `impl` | Working in the cluster and committed to git |
| `codified` | Survives `terraform destroy` + `apply` + `argocd sync` with **no manual steps** |
| `broke-it` | One deliberate failure, diagnosed, written up in `docs/incidents/` |
| `drill` | 5 interview questions answered cold, no hints, answers logged below the topic |
| `decision` | An entry in `DECISIONS.md` naming the choice and the rejected alternative |

`codified` is the one I'll be tempted to skip. It is the one that catches the problem already
in this repo: `scripts/bootstrap-cluster.sh` creates the OIDC provider with `eksctl` and
annotates a ServiceAccount with `kubectl`, so the cluster's IAM foundation lives outside
Terraform state. It works today and vanishes on rebuild.

**Rule: one topic per session. No batching, no skipping ahead.**

---

## Stage 0 — Foundations & loop safety

No cluster needed. Costs $0. Everything after this assumes it.

- [ ] **The operator / controller pattern (CRD + reconcile loop)**
  - Why: ESO, Prometheus Operator, Argo, Kyverno, Karpenter and cert-manager are all the same
    shape. Learn the shape once and six installs stop being magic.
  - Cost: $0
  - Interview: "What is a Kubernetes controller? What does 'level-triggered reconciliation'
    mean and why is it better than edge-triggered for infrastructure?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Liveness, readiness and startup probes**
  - Why: all three Deployments in `deploy/k8s/` have none. No readiness gating means every
    rollout drops requests.
  - Cost: $0
  - Interview: "Difference between liveness and readiness? When does a liveness probe make an
    outage *worse*?" (catalogue holds a MySQL connection — this is the trap)
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Resource requests, limits and QoS classes**
  - Why: HPA cannot compute a target percentage without CPU requests. Blocks Stage 7 entirely.
  - Cost: $0
  - Interview: "Requests vs limits? What is CPU throttling and why is a CPU limit often
    harmful? Name the three QoS classes and which gets evicted first."
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **securityContext: non-root, read-only rootfs, dropped capabilities**
  - Why: all three containers currently run as root.
  - Cost: $0
  - Interview: "What does runAsNonRoot actually enforce, and what breaks when you set
    readOnlyRootFilesystem on a Node app?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **CI gates: `go test`, `npm test`, `kubeconform`, `kube-score`**
  - Why: `app/catalogue/service_test.go` exists and **no pipeline runs it**. Two shipped bugs
    (`60e32fa`, `0bfc0b9`) were Service targetPort errors a manifest check would have caught.
  - Cost: $0
  - Interview: "What's the difference between having tests and running them in CI? Order the
    stages of a pipeline and justify the order."
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Supply chain scanning: `trivy`, `gitleaks`**
  - Why: `mysql:5.7` is EOL and nothing scans it. No secret scanning on a repo that has a
    plaintext DB password in it.
  - Cost: $0
  - Interview: "Where in the pipeline does image scanning belong, and should a HIGH CVE block
    a merge? Defend your answer."
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Branch protection and required status checks**
  - Why: nothing can stop a broken commit reaching `main`, and ArgoCD self-heals from `main`
    — so `main` is a live deployment trigger.
  - Cost: $0
  - Interview: "Why is a required status check different from a test that merely reports?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Post-sync smoke test**
  - Why: if a sync produces a crashlooping pod, nothing currently tells me. No alert, no
    rollback, no signal.
  - Cost: $0
  - Interview: "What is a smoke test and why is it worth more than another unit test here?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Terraform hygiene in CI: `fmt`, `validate`, `tflint`, `checkov`, plan-on-PR**
  - Why: no checks at all on the Terraform, and `plan` as a PR comment is the single
    highest-value review artifact in infrastructure work.
  - Cost: $0 (add `infracost` and it also prices every PR)
  - Interview: "What does 'testing' mean for Terraform? What do you grep a plan for before
    approving it?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

---

## Stage 1 — Networking & DNS

The layer that causes the most real EKS incidents and the one most candidates can't explain.

- [ ] **Pod networking and the AWS VPC CNI**
  - Why: EKS gives every pod a real VPC IP. That one fact drives subnet sizing, max-pods per
    instance type, and the most common EKS outage there is.
  - Cost: $0
  - Interview: "Why does a `t3.medium` cap out at 17 pods? What is IP exhaustion, how would
    you diagnose it, and what are prefix delegation and secondary CIDRs?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Service types, kube-proxy and how a request actually reaches a pod**
  - Why: `front-end` calls `http://catalogue` and it works. I should be able to trace exactly
    why, including the recent targetPort 8080 fix.
  - Cost: $0
  - Interview: "Walk a packet from the ALB to the catalogue container. What does kube-proxy
    do, and what changed with IPVS and with eBPF-based CNIs?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **CoreDNS: resolution, caching, ndots and failure modes**
  - Why: DNS is the single most common cause of intermittent cluster weirdness.
  - Cost: $0
  - Interview: "A service resolves intermittently. Walk me through diagnosing it. What is the
    ndots:5 problem and how do you fix it?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Verify the VPC subnet tags the ALB controller depends on**
  - Why: the controller discovers subnets via `kubernetes.io/role/elb`. I did not see those
    tags in the VPC module — if Ingress works today, something tagged them out of band, which
    means a rebuild silently breaks it. This is a `codified` failure hiding in plain sight.
  - Cost: $0
  - Interview: "How does the AWS Load Balancer Controller decide where to put an ALB?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

---

## Stage 2 — Identity

- [ ] **OIDC federation from first principles**
  - Why: the concept behind IRSA, Azure Workload Identity, GCP Workload Identity Federation
    *and* the GitHub Actions → AWS auth this repo already uses. One idea, four appearances.
  - Cost: $0
  - Interview: "How does a pod get AWS credentials with no secret stored anywhere? What is
    actually exchanged, and what signs it?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **IRSA, moved into Terraform**
  - Why: the OIDC provider and the ALB controller role are created by `eksctl`/`kubectl` in
    `scripts/bootstrap-cluster.sh` — outside Terraform state.
  - Cost: $0
  - Interview: "Explain the trust policy. What does the `sub` condition do and what happens
    if you omit it?" (the answer is a privilege-escalation path — know it)
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **EKS Pod Identity, and when to prefer it**
  - Why: the newer, simpler mechanism. Being able to compare the two is the interview win.
  - Cost: $0
  - Interview: "IRSA vs Pod Identity — what problem does Pod Identity solve, and why would
    you still see IRSA everywhere?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

---

## Stage 3 — Secrets

- [ ] **External Secrets Operator + AWS Secrets Manager**
  - Why: `deploy/k8s/catalogue-db-deploy.yaml` has `MYSQL_ROOT_PASSWORD: "admin"` in
    plaintext in git, next to `MYSQL_ALLOW_EMPTY_PASSWORD=true`.
  - Cost: ~$0.40/secret/month
  - Interview: "ESO vs the Secrets Store CSI driver vs SOPS vs Sealed Secrets. Pick one for a
    multi-cloud estate and defend it. Where does the secret end up in each case?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Secret rotation**
  - Why: rotation is the whole reason to pay for Secrets Manager over Parameter Store.
  - Cost: included above
  - Interview: "A secret rotates. The pod has the old value cached. What happens, and how do
    you make the app pick up the new one without downtime?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

---

## Stage 4 — TLS & DNS automation

- [ ] **cert-manager + ACM, and TLS on the Ingress**
  - Why: `deploy/k8s/ingress.yaml` is **HTTP only** — no certificate, no TLS block, no
    redirect. A public e-commerce demo served over plaintext is the first thing an interviewer
    will notice.
  - Cost: ACM public certs are free; cert-manager is free
  - Interview: "Where should TLS terminate — ALB or pod? What is mTLS and do you need it
    here? ACM vs Let's Encrypt via cert-manager?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **ExternalDNS + Route53**
  - Why: stop quoting raw ALB hostnames. Needs IRSA, so it's a payoff for Stage 2.
  - Cost: Route53 hosted zone $0.50/month + domain registration
  - Interview: "How does ExternalDNS avoid fighting with another controller over the same
    record? What is the TXT registry for?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

---

## Stage 5 — Managed database

The stage that makes the cluster genuinely disposable.

- [ ] **RDS MySQL: subnet groups, security groups, parameter groups**
  - Why: `catalogue-db` is a pod with no PersistentVolume. The data dies with the cluster, and
    I have never dealt with the stateful thing that must outlive the compute.
  - Cost: ~$12-15/month for `db.t4g.micro`
  - Interview: "Why is the DB in a private subnet with no public access, and how does a pod
    reach it? What is a DB subnet group and why does it need two AZs?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **MySQL 5.7 → 8.0 migration**
  - Why: 5.7 is EOL, and on RDS that means **extended support bills extra per vCPU-hour**. So
    8.0 is both correct and cheaper. `dump.sql` may need charset/collation and auth-plugin work.
  - Cost: avoids an extended-support surcharge
  - Interview: "How do you plan a major version database upgrade with no downtime?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Seeding and the day-2 bootstrap problem**
  - Why: `dump.sql` has to get in, and `catalogue_user` has to be created *inside* the DB.
  - Cost: $0
  - Interview: "Terraform created the DB and the master password. Who creates the application
    user, and why is a Terraform `local-exec` the wrong answer?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Terraform state layout: what must outlive a cluster destroy**
  - Why: arguably the most important architectural decision in this whole roadmap. RDS cannot
    live in the same root module as the cluster I destroy nightly.
  - Cost: $0
  - Interview: "How do you split Terraform state, and how do the pieces reference each other?
    Why not one big state file? Why not Terragrunt?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Connection pooling and the real bottleneck**
  - Why: catalogue opens connections per request against a `t4g.micro`. The DB connection
    limit is the ceiling no amount of pod autoscaling can get past — and discovering that is
    the best lesson in Stage 7.
  - Cost: $0
  - Interview: "You scale pods 10x and throughput doesn't improve. Where do you look first?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

---

## Stage 6 — Observability

`catalogue` already serves `/metrics` via `promhttp` and is already OpenTracing-instrumented.
So this is platform work, not app work.

- [ ] **kube-prometheus-stack, and what the operator installed**
  - Why: Prometheus/Grafana currently exist only in `deploy/docker-compose/`, which monitors
    nothing real.
  - Cost: ~$3-5/month for the EBS volume
  - Interview: "Pull vs push. Why does Prometheus pull? What breaks about that for batch jobs,
    and what is Pushgateway for?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **ServiceMonitor and scraping catalogue's existing `/metrics`**
  - Why: the endpoint is already there and nothing scrapes it.
  - Cost: $0
  - Interview: "Why did a CRD replace scrape annotations? What are relabel_configs for?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **PromQL, by hand**
  - Why: writing it is the skill; importing a dashboard is not.
  - Cost: $0
  - Interview: "Write me a p99 latency query from a histogram. What's the difference between
    `rate` and `irate`, and why is averaging a histogram_quantile across pods wrong?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Golden signals dashboard, built by me**
  - Why: one dashboard I made beats twenty I imported.
  - Cost: $0
  - Interview: "Name the four golden signals. What are RED and USE and when does each apply?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Alertmanager, routed somewhere I'll actually see**
  - Why: an alert that goes nowhere is a dashboard.
  - Cost: $0
  - Interview: "Symptoms vs causes — which do you alert on and why? What's alert fatigue and
    how do you measure whether you have it?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **SLIs, SLOs, error budgets and multi-window burn-rate alerts**
  - Why: this is the single most senior-signalling topic in the whole curriculum.
  - Cost: $0
  - Interview: "Define an SLI for catalogue. Set an SLO. Now tell me what a 2% error budget
    means operationally, and why you alert on burn rate instead of a threshold."
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Logs: Loki + structured JSON with trace IDs**
  - Why: correlating a log line to a trace is the actual skill.
  - Cost: ~$1-2/month
  - Interview: "Loki vs Elasticsearch vs CloudWatch Logs — what's the architectural difference
    and what does Loki deliberately not do?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Traces: OpenTelemetry Collector + Tempo**
  - Why: the app speaks Zipkin already, and the Collector can accept it and forward — so
    **zero app changes**. The payoff is ALB → front-end → catalogue → MySQL as one trace.
  - Cost: ~$1/month
  - Interview: "What is context propagation and how does a trace ID survive a service
    boundary? What does the Collector give you over pointing apps straight at a backend?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

---

## Stage 7 — Scaling

- [ ] **metrics-server and HPA on CPU**
  - Why: the obvious first step, and the one that proves Stage 0's requests were real.
  - Cost: spot-bursty
  - Interview: "Walk the HPA control loop. What is the stabilization window and why does it
    exist? What happens if requests aren't set?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Custom metrics: prometheus-adapter and scaling on RPS**
  - Why: CPU is the wrong signal for an I/O-bound DB reader. This is the honest answer.
  - Cost: $0
  - Interview: "Why is CPU a bad autoscaling signal for this service? What would you scale on
    and how does the custom metrics API work?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Karpenter**
  - Why: node autoscaling, and where modern EKS actually lives.
  - Cost: spot-bursty
  - Interview: "Karpenter vs Cluster Autoscaler — what constraint does Karpenter remove? What
    is consolidation and how can it bite you?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Load testing with k6**
  - Why: tuning without numbers is guessing.
  - Cost: $0
  - Interview: "Open vs closed workload models. What's the difference between a load test, a
    stress test and a soak test?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **PDBs, topology spread, graceful shutdown and spot interruptions**
  - Why: `replicas: 1` means every rollout is an outage, and spot nodes vanish with 2 minutes'
    notice. This is the part people forget when they claim zero downtime.
  - Cost: $0
  - Interview: "A node is draining and your pod is serving a request. Walk me through
    everything that has to be right for that request to complete."
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

---

## Stage 8 — Delivery maturity

- [ ] **Kustomize overlays and a dev/prod split**
  - Why: only `terraform/env/main` exists, and `deploy/k8s/` is a flat directory. Promotion
    between two environments is what teaches why immutable artifacts matter.
  - Cost: a second cluster is expensive — decide whether dev is a namespace or a cluster
  - Interview: "Kustomize vs Helm — where's the boundary? What belongs in an overlay and what
    belongs in a chart value?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Kill the `sed` bot: Argo CD Image Updater or a config repo**
  - Why: `deploy-to-eks.yml` seds image tags and pushes to `main`, so `main` can never be
    branch-protected. Note the `app/**` paths filter is the only thing preventing an infinite
    CI loop — that's load-bearing and undocumented.
  - Cost: $0
  - Interview: "Why does GitOps say CI shouldn't hold cluster credentials? Mono-repo vs config
    repo — argue both sides."
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Argo Rollouts: canary with automated analysis and rollback**
  - Why: the payoff. A bad image rolls itself back without me.
  - Cost: $0
  - Interview: "Canary vs blue/green for a 3-service app on one database. What's the
    AnalysisTemplate measuring and what makes a good rollback trigger?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Expand/contract database migrations**
  - Why: the hardest part of continuous deployment, and the thing that makes rollback real.
  - Cost: $0
  - Interview: "You need to rename a column with zero downtime and the ability to roll back.
    Walk me through every deploy."
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **What rollback means under `selfHeal: true`**
  - Why: `kubectl rollout undo` does nothing when Argo heals it straight back. I need to know
    this before an incident, not during one.
  - Cost: $0
  - Interview: "Argo is self-healing and prod is broken. What are your options, in order?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

---

## Stage 9 — Hardening & policy

- [ ] **Pod Security Standards at `restricted`**
  - Interview: "What replaced PodSecurityPolicy and why? What are the three PSS levels?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Kyverno: policy as code, Audit before Enforce**
  - Why: the Stage 0 CI rules, now also enforced at admission. Same rule, two enforcement
    points — that symmetry is the idea worth articulating.
  - Interview: "Kyverno vs OPA Gatekeeper. Should a missing resource limit be rejected or
    silently defaulted? What's a validating vs mutating admission webhook?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **NetworkPolicy, default-deny**
  - Why: anything in the cluster can currently reach the database.
  - Interview: "Why is default-deny hard to retrofit? VPC CNI network policy vs Calico?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **RBAC, ServiceAccounts and least privilege**
  - Interview: "Role vs ClusterRole. How would you audit who can delete a pod in prod?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **cosign signing + verification at admission**
  - Why: the end-to-end supply chain story, from the Stage 0 CI to the cluster refusing an
    unsigned image.
  - Interview: "What is keyless signing and what is actually being trusted? What is SLSA
    provenance?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **trivy-operator and kube-bench**
  - Interview: "What is the CIS benchmark and which of its findings can't you fix on EKS?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Audit: EKS control plane logs + CloudTrail**
  - Why: "who did what" is the first question in every real incident and every compliance
    conversation.
  - Cost: CloudWatch Logs ingestion — watch this one
  - Interview: "Someone deleted a Deployment in prod. How do you find out who?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

---

## Stage 10 — Operate it hard

The stage with the interview stories in it. Do not let it get compressed because Azure looks
more interesting.

- [ ] **A live cluster upgrade: 1.30 → 1.31 → 1.32**
  - Why: the most valuable single exercise here. Every platform team fears it; most candidates
    have never done one.
  - Cost: $0 extra
  - Interview: "Walk me through an EKS upgrade. What order, what's the deprecated-API report,
    how do you know your PDBs hold, and what do you do about addon version skew?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Node-level debugging: pressure, evictions, OOM, disk**
  - Why: where real incidents actually live, below the Kubernetes abstraction.
  - Cost: $0
  - Interview: "A node goes NotReady. Walk your diagnosis. What's the eviction order under
    memory pressure, and what does the OOM killer pick?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Velero backup and a proven restore**
  - Why: an untested backup is not a backup. Restore into a *fresh* cluster or it doesn't count.
  - Cost: S3 storage, pennies
  - Interview: "What does Velero back up that `terraform apply` can't recreate? Define RTO and
    RPO for this app and justify the numbers."
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **RDS failover and point-in-time restore drill**
  - Why: the database is the part you cannot rebuild from git.
  - Cost: Multi-AZ doubles DB cost — turn it on for the drill, then off
  - Interview: "Trigger a Multi-AZ failover. What does the application see, and for how long?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Chaos drills — five of them, written up**
  - Why: drain a node mid-deploy · expire a secret · bad SHA in Argo · DB slow (not dead) ·
    connection pool exhausted · forced spot interruption. **Slow is harder than dead.**
  - Cost: $0
  - Interview: "Tell me about a time you broke production." (This is the question. These are
    your answers.)
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **On-call for real: get paged**
  - Why: Alertmanager → a free-tier PagerDuty/Opsgenie → my actual phone, with a runbook per
    alert. An SLO you've never been woken by isn't an SLO.
  - Cost: free tier
  - Interview: "What makes a good runbook? What's the difference between an alert and a page?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Blameless postmortems**
  - Why: `docs/incidents/` becomes the artifact nobody else brings to an interview.
  - Cost: $0
  - Interview: "What makes a postmortem blameless, and what's a contributing factor vs a root
    cause? Why is 'human error' never an acceptable root cause?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Cost: tagging, Infracost, Budgets, rightsizing**
  - Why: cost is a platform team's actual KPI, and `terraform destroy` leaves the ALB orphaned
    and billing.
  - Cost: saves money
  - Interview: "How would you cut this cluster's bill by 40%? What's a Savings Plan vs a
    Reserved Instance vs spot, and what's the risk of each?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Terraform drift detection**
  - Why: closes the loop on the `eksctl` problem. A scheduled `plan` that alerts on drift.
  - Cost: $0
  - Interview: "What is drift, how do you detect it, and what do you do when you find it?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

---

## Stage 11 — Platform as a product *(stretch)*

Optional, and the thing that separates "DevOps engineer" from "platform engineer".

- [ ] **Multi-tenancy: namespaces, ResourceQuota, LimitRange, tenant RBAC**
  - Interview: "Two teams share a cluster. How do you stop one starving the other? When does
    a namespace stop being enough and you need a separate cluster?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **A golden path: one PR gets a developer a namespace, a database and a pipeline**
  - Interview: "What does 'platform as a product' mean? Who are your users and what's your SLA
    to them?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Backstage or a self-service portal** *(optional)*
- [ ] **Service mesh: Linkerd — mTLS and traffic shifting** *(optional; Istio only if asked)*

---

## Stage 12 — Port to Azure, then GCP

Only once the AWS build is monitored and has survived being attacked.
**The deliverable is `docs/cloud-diff.md`, not a cluster.** Keep the app and Helm chart
identical so everything learned is platform delta.

- [ ] **AKS: cluster, Entra Workload Identity, ACR, Key Vault + CSI, Flexible Server**
  - Cost: **control plane is free** — much cheaper than EKS, so clusters can stay up longer
  - Interview: "Compare AKS and EKS on identity, ingress and node management."
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **One pipeline in Azure DevOps Pipelines**
  - Why: enterprise Azure shops live there, and environments + approvals is a different model.
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **Bicep: the same infra in a first-party IaC language**
  - Interview: "Terraform vs Bicep vs CloudFormation — when would you not pick Terraform?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **GKE Autopilot: Workload Identity Federation, Artifact Registry, Cloud SQL proxy**
  - Cost: free zonal control-plane tier
  - Interview: "What does Autopilot take away, and what does that mean for Karpenter-style
    node control? When is it the wrong choice?"
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **GKE Standard, for the comparison**
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

- [ ] **`docs/cloud-diff.md` complete across all three**
  - Why: the single most credible artifact for the multi-cloud claim.
  - Gates: `[ ] impl` `[ ] codified` `[ ] broke-it` `[ ] drill` `[ ] decision`

---

## Continuous — not a stage

- [ ] `docs/cloud-diff.md` row added at every AWS-shaped decision, from Stage 2 onward
- [ ] `DECISIONS.md` entry per topic (gate 5)
- [ ] `README.md` kept current: architecture diagram, stand-up, tear-down
- [ ] An architecture diagram I can draw from memory on a whiteboard
- [ ] Screenshots worth keeping: the autoscaling graph, the automated rollback, the upgrade
      with no 5xx
