---
name: change-quality-check
description: Use this skill when the user wants a code change to stay concise, well-structured, and maintainable, especially when they want cleaner implementation, less patch-stacking, scoped refactoring, and a final check for whether the change altered anything the code cannot show.
---

# Change Quality Check

## Overview

Use this skill to keep implementation work structurally clean instead of patch-oriented. Favor small, coherent abstractions, preserve module boundaries, refactor newly affected code when the change would otherwise leave duplication, tangled responsibilities, or confusing control flow behind, and finish by checking whether the final change altered anything the code cannot show.

## Working Style

Treat every code change as both an implementation task and a local design review. Before editing, identify the current responsibility boundaries, the smallest stable place for the new behavior, and whether the surrounding code is already showing signs of strain.

Prefer these outcomes:

- Extend an existing abstraction when it remains coherent.
- Check nearby abstractions, naming, and data flow before adding new logic.
- Extract a new helper, module, or component when the new behavior would otherwise make the current unit harder to read.
- Reuse an existing helper, service, hook, mapper, schema, or domain module when it already owns most of the behavior.
- Rename vague identifiers when the new change exposes that the old naming no longer fits.
- Consolidate repeated conditionals, mapping logic, validation, formatting, or state transitions introduced by the change.
- Keep UI focused on rendering and interaction; keep fetching, transformation, validation, and persistence in the appropriate layer.

Avoid these patterns unless the user explicitly asks for the smallest possible diff:

- Adding one-off branches into already crowded functions.
- Copying nearby logic and changing a few literals.
- Appending new flags, booleans, or optional parameters when a clearer abstraction would remove the need.
- Hiding structural debt behind comments or TODOs instead of fixing the nearby design.

## Decision Rules

Use this sequence while working:

1. Find the narrowest responsible layer for the change.
2. Check whether an existing abstraction already owns most of that behavior.
3. If not, add or extract the smallest abstraction that keeps the code easier to understand after the change than before it.
4. After implementing, inspect the touched area for local cleanup that is now justified by the new code.
5. Check whether the final change altered a business rule, external constraint or decision that the code cannot show.

Keep refactors scoped. Do not turn a feature request into a broad rewrite. Limit cleanup to code that is directly touched, newly stressed, or now clearly duplicated because of the change.

## Refactor Triggers

Perform a follow-up refactor when one or more of these conditions appear after the initial implementation:

- The same idea is represented in more than one place.
- A function or component now has more than one clear reason to change.
- Control flow became harder to scan because of nested branching or early special cases.
- New names do not match the real responsibility anymore.
- A caller now knows too much about callee internals.
- State shaping, data normalization, or error handling is repeated across nearby sites.

See [references/refactor-checklist.md](references/refactor-checklist.md) for the detailed checklist.

## Documentation Check

Code comes first. Documents hold only what the code cannot show: business rules, external constraints, and decisions with their reasons. Where the repository's `AGENTS.md` says more, follow it.

Before closing the task, update a document only when one of these holds:

- The final change altered a rule, constraint, or decision that a reader could not learn from the code.
- A document now says something false. Correct or remove that statement.

Otherwise change no document. Do not record architecture, file layout, routes, schema, plans, rollout status, or history.

When a document does need changing:

- Read only the document that owns the topic.
- Revise an existing document rather than adding a new file.
- Replace or remove stale text instead of appending notes.
- Keep the wording short and durable.

If the difference between code and docs looks like a bug, unfinished work, or accidental behavior drift, stop and report that concern instead of forcing docs to match.

See [references/documentation-sync-checklist.md](references/documentation-sync-checklist.md) for the detailed checklist.

## Constraints

Preserve behavior unless the user asked for a behavior change. Favor reversible structural improvements over clever rewrites. If a broader refactor is clearly warranted but exceeds the task scope, note it briefly and keep the implementation itself disciplined.

Do not weaken tests to make an implementation pass. If tests fail, first assume the implementation may be wrong. Change tests only when the requested behavior or contract genuinely changed, and state that reasoning clearly.

## Output Expectations

When reporting completed work:

- Briefly describe the structural change, not just the feature change.
- Mention any local refactor you performed and why it reduced complexity.
- If no refactor was needed, state that the surrounding structure remained coherent.
- If a document changed, name it and the rule it records.
- If you intentionally avoided a larger refactor, state the boundary you chose.
- Mention any remaining structural risk or follow-up cleanup worth considering.
