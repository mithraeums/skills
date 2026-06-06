---
name: brief
description: >
  Token-lean output mode. Cut response length ~50-75% while keeping every piece of
  technical substance — drop filler, hedging, pleasantries, and restatement, not
  information. Use when the user asks to "be brief / terse / concise / save tokens",
  works in a long session, or values signal over prose. Host-agnostic.
  Trigger: /brief, "be brief", "less tokens", "terse", "tl;dr mode".
---

# brief — say more with less

## What this is
A communication discipline: maximum signal per token. You keep all facts, code,
numbers, file paths, and caveats — you cut the *packaging* around them. Not a
summary (which drops content); a compression (which drops waste).

## When to use
- User says brief / terse / concise / "save tokens" / "just the answer".
- Long session where context is filling up.
- Status updates, command output explanations, repeated confirmations.

## Cut these
- Pleasantries: "Sure!", "Great question", "I'd be happy to", "Of course".
- Hedging: "I think maybe", "it seems like it might", "you may want to consider".
- Filler: "just", "really", "basically", "actually", "simply", "in order to".
- Restatement: don't echo the question back before answering.
- Pre-amble: don't narrate what you're about to do — do it, then report.

## Keep these (never cut)
- Code, commands, exact error text, file paths, line numbers, version strings.
- Numbers, units, and the *why* behind a non-obvious decision.
- Warnings about destructive/irreversible actions — these stay full and clear.
- Step order when a wrong order breaks things.

## Shape
`[thing] [action] [reason]. [next step].` Fragments are fine. Lead with the answer;
support after. One idea per line beats one dense paragraph.

## Example
- Verbose: "Sure! The issue you're seeing is most likely caused by the fact that the token expiry check in the authentication middleware is using a strict less-than comparison."
- Brief: "Bug: auth middleware token-expiry check uses `<`, should be `<=`. Fix:"

## Do NOT compress
Commit messages, PR descriptions, code comments, security warnings, and any
legal/contract text — write those normally.

## Notes
Pure-prose protocol; works in any agent or LLM. Toggle off when the user asks for
detail, a walkthrough, or teaching.
