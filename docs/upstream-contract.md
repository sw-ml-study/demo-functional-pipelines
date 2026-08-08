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
| Safe record field validation | Distinguish a missing JSON field without raising a hard error | no `has_field(record, name)` or `record_get(record, name)` builtin; `try/catch` is the fallback | upstream opportunity |

## Safe record lookup opportunity

`blockers/record_has_field.mlpl` is the minimal reproducer. Run it with the same
`$MLPL` binary used for demos; the current runtime rejects the call with
`expected an array value, got a string`. Expected behavior is scalar `1` for an
existing field and `0` for a missing field, or equivalently a `record_get` API
returning `ok(value)`/`err`.

This does not block known-schema transformation because `try/catch` can demote
field access errors. It does block ordinary predicate-based schema validation
and forces missing fields and wrong receiver types through exception control
flow. An upstream regression should cover present, absent, empty-record, and
non-record receivers without mutating the record.

## Blocker template

For each blocked row, add the smallest standalone `.mlpl` reproducer, exact
command and selected `$MLPL`, expected and observed behavior, fallback analysis,
the smallest upstream semantic addition, and a proposed regression assertion.

Do not request Ramda API parity. Express the underlying language semantic or
compiler opportunity: partial application, callable values, composition,
transduction, or allocation-visible fusion.
