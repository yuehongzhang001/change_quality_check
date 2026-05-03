# Refactor Checklist

Use this checklist after implementing the requested behavior.

## Duplicate Logic

- Did the change copy validation, formatting, mapping, branching, or state update logic from another location?
- Can the shared logic be extracted without creating an over-general helper?

## Responsibility Boundaries

- Does the edited function, class, component, or module still have one dominant responsibility?
- Did UI code absorb business logic that belongs in a service or utility?
- Did orchestration code absorb low-level transformation details that should live closer to the data?

## API Shape

- Did the change add flags or optional parameters that encode multiple modes?
- Would separate functions, objects, or strategies make the call sites easier to read?

## Readability

- Can the main path be understood quickly without scanning several exceptional branches?
- Are nested conditionals flattenable through guard clauses, helper extraction, or data reshaping?
- Do names still match what the code actually does?
- Did the change add one-off flags or special cases that should really be modeled as a clearer abstraction?

## Tests

- Did the implementation force tests to couple more tightly to internals than to behavior?
- If tests changed, was that because the requirement or contract changed rather than because the implementation was awkward?

## Local Consistency

- Does the touched code follow the surrounding project's patterns where those patterns are still healthy?
- If the local pattern is already degraded, did the new change avoid deepening the problem?

## Scope Control

- Is the cleanup tightly connected to the requested change?
- If a larger redesign is needed, can it be called out separately without blocking this task?
