---
name: debug
description: >
  Find the real cause of a bug before touching code: read the evidence first (logs, the
  exact bytes, the session record), reproduce it, shrink it, then fix it with a test that
  fails on the old code and passes on the new. Stops "fixed" bugs that come back and fixes
  aimed at the wrong layer. Use for any bug report, flaky test, "it hangs", "it worked
  yesterday", or a fix that did not hold. Host-agnostic.
  Trigger: /debug, "why does", "it broke", "still broken", "flaky", "it hangs", "repro".
---

# debug: evidence, repro, proof

## Order (do not skip ahead)
1. **Read the evidence first.** Logs, the session or request record, the exact input bytes,
   the version/build stamp of what actually ran. A week of guessing loses to one log read.
   Confirm the running binary is the one you built.
2. **Reproduce it.** Same input, same size, same environment. A repro that does not fail
   is not a repro: check it fails BEFORE the fix.
3. **Shrink it.** Cut the input and the code path until removing anything makes it pass.
   A tiny standalone repro (one file, one function) often isolates in minutes what reading
   could not in hours.
4. **Name the cause in one sentence** with the line that proves it. "Probably" is not a cause.
5. **Fix at the cause**, not where the symptom showed. Search for the same pattern
   elsewhere: a bug class rarely lives in one place.
6. **Prove it.** A test that fails on the old code and passes on the new: run it both ways
   (revert the fix, watch it fail). Then the full suite, plus sanitizers if the language has them.

## Traps
- **Suspect the test's shape before the code** when a fix "passes" but the bug survives:
  short inputs, results that fit the screen, one turn instead of two, a mock that cannot do
  what the real thing does.
- Coincidence reads as pattern: two failures after a rebuild may share nothing but timing.
  Print the variable you think explains it before concluding.
- A diagnostic you throw away is a bug you cannot fix remotely: capture stderr, exit
  status and signals; log why, not just what.
- Silent fallbacks hide causes. Look for `if (!x) continue;`, empty catch blocks, default values.
- Lengths: a formatter's return value is what it WOULD have written, not what it wrote.

## Report
cause (one sentence + file:line) · repro (command) · fix · proof (test name, fails before /
passes after) · same-class sites checked.

## Notes
Pairs with `ship` (the gates before a push) and `handoff` (record what was ruled out).
