# Documentation Sync Checklist

Use this checklist after the implementation is complete and before closing the task.

## Relevance

- Does the final change alter user-visible behavior?
- Does it change business rules or validation expectations?
- Does it change schema, API, RPC, event, or native integration contracts?
- Does it change auth, permission, security boundaries, or trust assumptions?
- Does it change operator, admin, reviewer, or storefront workflows?
- Does it establish a stable architectural decision or new long-term project constraint?

## Document Selection

- Which existing document already owns this topic?
- Do repository instructions require starting from `documents/README.md`?
- Can the update be handled by revising one central document instead of adding a new file?

## Consistency

- Are there stale statements that now conflict with the final behavior?
- Is the wording durable, concise, and about stable rules rather than implementation noise?
- Does the difference between code and docs reflect intentional behavior rather than a bug or unfinished work?

## Scope Control

- Is the documentation update tightly connected to the current change?
- If no documentation update was needed, is the reason concrete and defensible?
