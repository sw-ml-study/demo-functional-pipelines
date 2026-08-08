# Upstream capability contract

This is the boundary between runnable downstream teaching material and changes
that belong in sw-MLPL. A blocker is actionable only when it includes a minimal
program, expected behavior, observed behavior, and fallback assessment.

## Capability matrix

| Capability | Demo need | Current route | Status |
|---|---|---|---|
| First-class named functions | Reusable stages | sw-MLPL UDFs | available |
| Array transformation | Transform without mutation | `each(:u:fn, values)` | available |
| Predicate selection | Retain matching values | `compress(mask, values)` | available |
| Left reduction | Collapse with an accumulator | `reduce(:add, values)` plus an explicit empty identity | available |
| Pipeline composition | Feed one stage into the next | named UDF with explicit intermediate values | available |
| Bound reusable predicate | Reuse one threshold across a branch mask | partial from `call(:u:at_least, threshold)` | available |
| Fallible branch result | Keep invalid domain input in the value flow | `ok(...)`, `err(...)`, and records | available |

## Blocker template

For each blocked row, add the smallest standalone `.mlpl` reproducer, exact
command and selected `$MLPL`, expected and observed behavior, fallback analysis,
the smallest upstream semantic addition, and a proposed regression assertion.

Do not request Ramda API parity. Express the underlying language semantic or
compiler opportunity: partial application, callable values, composition,
transduction, or allocation-visible fusion.
