# Incidents

One file per deliberate breakage. Gate 3 of every curriculum topic.

These are the most valuable pages in this repo. "Tell me about a time you broke production"
is asked in every platform interview, and most candidates have nothing. Each of these is an
answer.

Filename: `NN-short-slug.md` — e.g. `01-liveness-probe-restart-storm.md`

## Template

```
# <What broke>
Date: YYYY-MM-DD · Topic: <curriculum topic> · Caused on purpose: yes/no

## Symptom
What I saw first, in the order I saw it. Exact error text, pod state, log line, graph shape.
Not what it turned out to be — what it LOOKED like.

## What I thought it was
My first hypothesis, honestly. Including the wrong ones. This section is the whole point:
the gap between the symptom and the cause is where the learning is.

## How I found the cause
The commands I actually ran, in order. kubectl describe, logs --previous, events, exec,
the AWS CLI call. Note which ones were dead ends.

## What it actually was
The mechanism, one paragraph. Why this symptom followed from this cause.

## Fix
What I changed. Immediate mitigation vs real fix — say which was which.

## How I'd detect it next time
The alert, dashboard panel, or CI check that would have caught it. If the answer is
"nothing would have", that's a finding — write it down and add it to the curriculum.

## Time to diagnose
Honest number. It should drop over the first five of these.
```

## Rules

- Write it the same day, while the confusion is still fresh. A tidied-up version written a
  week later is useless — the wrong hypotheses are the content.
- **"Human error" is never a cause.** If a wrong command took the cluster down, the finding is
  that the command was possible, not that you ran it.
- Separate contributing factors from the trigger. There's usually one trigger and three
  conditions that let it matter.
