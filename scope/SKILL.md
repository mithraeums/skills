---
name: scope
description: >
  Turn a vague request into a scoped plan before building — explicit goal, explicit
  non-goals, the smallest viable first step. Use at the start of any non-trivial task,
  when a request is ambiguous or could balloon, or when you catch yourself about to
  over-build. Stops scope creep and wasted work. Host-agnostic.
  Trigger: /scope, "plan this", "before we build", "what's the smallest version", "is this in scope".
---

# scope — plan before you build

## What this is
A short discipline that runs *before* implementation: decide what you're building,
what you're explicitly **not** building, and the smallest step that proves the
direction. Five minutes here saves an hour of building the wrong thing.

## When to use
- Any non-trivial or multi-step task.
- The request is vague, broad, or could expand ("make it flexible", "handle everything").
- You feel the urge to add abstraction, config, or "while I'm here" extras.

## The pass
1. **Restate the goal** in one sentence — the user-visible outcome, not the mechanism. Confirm if unsure.
2. **List non-goals** — explicitly name what you will NOT do this round. This is the highest-value step; it's where creep dies.
3. **Smallest viable step** — the least work that delivers or de-risks the goal. Ship/learn from it before expanding.
4. **Surface unknowns** — the 1-3 questions whose answers change the plan. Ask only those; don't interrogate.
5. **Name the verify** — how you'll know it worked (run it, a test, an observed behavior).

## Output
```
Goal: <one sentence, user-visible>
Non-goals: <what we're deliberately not doing now>
First step: <smallest thing that delivers/de-risks>
Open questions: <only the ones that change the plan>
Verify: <how we'll know it worked>
```

## Default to less
- No abstraction for single-use code.
- No config/flags nobody asked for.
- No rewrite disguised as a refactor.
- "Flexibility" and "future-proofing" are non-goals unless requested.
- One working slice beats a half-built general system.

## Notes
Pure planning protocol; any agent. The standalone essence of `corp`'s CEO. The
`Verify` line is the contract you hold yourself to before claiming the goal is met
— don't declare done until you've run it.
