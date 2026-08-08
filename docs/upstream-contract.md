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
| Safe record field validation | Distinguish a missing JSON field without raising a hard error | `has_field(record, name)` and Result-valued `record_get(record, name)` | available |

## Delivered safe record lookup

`tests/record_lookup.mlpl` pins the downstream contract: membership returns
scalar `1`/`0`, present lookup returns `ok(value)`, missing lookup returns a
structured `missing_field` error, and empty records are supported. The JSON
pipeline uses `record_get(...)?`, so missing fields remain ordinary Result data.

Wrong receiver and field-name types are intentionally hard errors. Domain type
validation of retrieved values remains the downstream pipeline's responsibility.

## Blocker template

For each blocked row, add the smallest standalone `.mlpl` reproducer, exact
command and selected `$MLPL`, expected and observed behavior, fallback analysis,
the smallest upstream semantic addition, and a proposed regression assertion.

Do not request Ramda API parity. Express the underlying language semantic or
compiler opportunity: partial application, callable values, composition,
transduction, or allocation-visible fusion.
