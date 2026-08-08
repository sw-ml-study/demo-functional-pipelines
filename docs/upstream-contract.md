# Upstream capability contract

This is the boundary between runnable downstream teaching material and changes
that belong in sw-MLPL. A blocker is actionable only when it includes a minimal
program, expected behavior, observed behavior, and fallback assessment.

## Capability matrix

| Capability | Demo need | Current route | Status |
|---|---|---|---|
| First-class named functions | Reusable stages | sw-MLPL UDFs | available |
| Array transformation | Transform without mutation | array primitives/combinators | verify in first executable slice |
| Predicate selection | Retain matching values | array primitives/combinators | verify in first executable slice |
| Left reduction | Collapse with an accumulator | array primitives/combinators | verify in first executable slice |
| Pipeline composition | Feed one stage into the next | UDF calls and shipped composition forms | verify in first executable slice |

## Blocker template

For each blocked row, add the smallest standalone `.mlpl` reproducer, exact
command and selected `$MLPL`, expected and observed behavior, fallback analysis,
the smallest upstream semantic addition, and a proposed regression assertion.

Do not request Ramda API parity. Express the underlying language semantic or
compiler opportunity: partial application, callable values, composition,
transduction, or allocation-visible fusion.
