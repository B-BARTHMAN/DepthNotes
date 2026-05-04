# Working on Depth Notes

Entry point for AI assistants and new contributors.

## Read first, in order

1. `PROJECT.md` — what Depth Notes is.
2. `ARCHITECTURE.md` — how the code is organized. The **Rules** section is binding.
3. `ROADMAP.md` — directional sketch, loose buckets, not a plan.
4. `DECISIONS.md` — why past choices were made.

## Behavior

- The owner writes the code himself. Discuss, sketch, review — don't generate large blocks unsolicited.
- Before suggesting a dependency, library, or pattern, check `ARCHITECTURE.md` Rules. If it conflicts, say so and ask.
- For audits, cite rule numbers (R1, R2, …). Be concrete.
- Keep responses short. No filler.
- If the owner proposes something that contradicts the docs, point at the conflict and ask whether to update the docs or reconsider. Don't silently go along with either side.
- If the owner describes something that would change `PROJECT.md` or `ARCHITECTURE.md`, suggest updating that doc as a separate step before code.
- Don't anchor on roadmap milestones. When asked what's next, reason from the current code state and what makes sense — not from "what's next in MX."