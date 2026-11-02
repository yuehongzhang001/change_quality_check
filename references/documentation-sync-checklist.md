# Documentation Checklist

Use this checklist after the implementation is complete and before closing the task. Most changes need no document.

## Relevance

- Could a reader learn this from the code? If yes, write nothing.
- Did a business rule change that the code does not explain?
- Did an external limit or third-party constraint change?
- Was a decision made whose reason the code cannot show?
- Does a document now say something false?

## Document Selection

- Which existing document already owns this topic?
- Can one existing document be revised instead of adding a new file?

## Consistency

- Is stale text replaced or removed rather than added to?
- Is the wording short and durable?
- Does the difference between code and docs reflect intentional behavior rather than a bug or unfinished work?

## Scope Control

- Is the update tightly connected to the current change?
- Is anything here architecture, layout, routes, schema, plans, rollout status, or history? If so, remove it.
