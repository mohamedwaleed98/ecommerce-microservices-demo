---
description: Teach one curriculum topic from scratch, nine steps, one at a time
---

Read `CLAUDE.md` and `docs/curriculum.md` first.

TOPIC FOR THIS SESSION: $ARGUMENTS

If no topic was given above, work the **first unticked topic** in `docs/curriculum.md` and
tell me which one you picked and why it's next.

Calibration: assume I have NO hands-on experience with this specific tool. You may assume
Linux, networking, containers and core Kubernetes objects (Deployment, Service, ConfigMap,
Secret, namespaces, kubectl). Assume nothing beyond that. If this topic needs a prerequisite
concept I haven't met, teach that first and tell me that's what you're doing.

My two goals, equally weighted:
  1. A working implementation in this repo.
  2. Being able to answer interview questions about it cold, in a platform engineer / SRE
     interview.

Teach it in the nine steps below. **STOP after each numbered step and wait for my reply.**
Do not deliver several steps in one message.

1. **THE PROBLEM.** What breaks without this tool — demonstrated in MY repo, with real file
   paths and line references. Don't name the tool yet.

2. **CALIBRATION.** Ask me 2-3 questions to find out what I already know here. Then adjust
   the depth of everything that follows based on my answers.

3. **THE MENTAL MODEL.** How it works conceptually: the control loop, the data flow, who
   talks to whom and in which direction. Include an ASCII diagram. This is the part that has
   to survive me forgetting the YAML.

4. **THE MOVING PIECES.** Every component I'll install or create. For each: what it's for,
   and whether it's a controller, a CRD, a cloud resource, or config. Name the ones that are
   easy to confuse with each other.

5. **THE DECISIONS.** Every choice I have to make, with honest trade-offs and your own
   recommendation plus reasoning. Flag which of these an interviewer is most likely to probe.

6. **WHERE TO READ.** Specific pages of the official documentation — not blog posts, not a
   link to a project homepage. Say which section of each page matters and why.

7. **WHAT TO TYPE.** A plain-language, ordered checklist of what I'm going to build. NO code,
   NO manifests, NO Terraform, NO Helm values — I type all of it myself. I'll paste it back
   and run `/review`.

8. **FAILURE SIGNATURES.** The 4-5 ways this most commonly breaks in the real world, and what
   each looks like from the outside: the exact error text, pod state, or log line I'd see.
   Then pick one for me to cause on purpose, and tell me what to look for.

9. **INTERVIEW DRILL.** Five questions a real platform/SRE interviewer would ask about this,
   easiest first, hardest last. Ask them ONE AT A TIME and wait for each answer. After each,
   tell me plainly whether it was correct, incomplete, or vague — and what a strong answer
   would have included. Vagueness marks what I didn't actually learn, so don't be polite.

RULES
- Never write implementation code unless I say `build`. If I've been stuck 30+ minutes and
  stopped learning, I'll say `unblock` and you give me the direct answer.
- If any step creates hourly-billed cloud resources, say so and estimate the monthly cost
  BEFORE I create it.
- Don't advance a step until I've actually answered. If my answer is hand-wavy, say so and
  ask again rather than moving on.
- Correct me when I'm wrong, especially when I'm confidently wrong. Don't soften it.
- Prefer "here's how to find out" over "here's the answer" when I could reasonably discover
  it with kubectl, the AWS CLI, or the docs.

CLOSING THE TOPIC
When the drill is done, check the five gates in `docs/curriculum.md` yourself — gates 1, 2, 3
and 5 are verifiable from the repo, so look rather than ask. Then either:
  - say which gate failed and exactly what's missing, or
  - tick the topic in `docs/curriculum.md`, log my drill answers under it, tell me what to add
    to `DECISIONS.md` / `docs/cloud-diff.md` / `docs/incidents/`, and name the next topic.

Start with step 1.
