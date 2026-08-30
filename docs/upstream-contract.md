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
| Transducer stages | Compose a transformation independent of source and sink | partials: `call(:u:map_t, fn)` leaves `(rf, acc, x)` outstanding | available |
| Expanding and Result-valued stages | One element in, many out; abort on the first `err` | `u:mapcat_t` and `u:validating_t` over `call`, `ok`, `is_ok` | available |
| Early fold termination | Stop pulling once the answer is known | downstream `u:reduced` record envelope, honored by each driver | approximated |
| Per-instance stage state | Stateful stages such as `take` | state threaded through the accumulator (`{left, inner}`) | approximated |
| Fold over any callable | Drive a fold with a user step function | none: `reduce` accepts only `:add`/`:mul`/`:min`/`:max`/`:and`/`:or` | blocked |
| Constant-time element access | Element-at-a-time drivers that stay linear | `take(v, 0, i)` copies the whole source per read | blocked |

## Delivered safe record lookup

`tests/test_record_lookup.mlpl` pins the downstream contract through five named
mlplunit tests: membership returns
scalar `1`/`0`, present lookup returns `ok(value)`, missing lookup returns a
structured `missing_field` error, and empty records are supported. The JSON
pipeline uses `record_get(...)?`, so missing fields remain ordinary Result data.

Wrong receiver and field-name types are intentionally hard errors. Domain type
validation of retrieved values remains the downstream pipeline's responsibility.

## Blocked: constant-time single-element access

Minimal program (`--source-dir` at the repository root, `$MLPL` =
`../sw-mlpl/target/release/mlpl-repl` 0.20.0):

```mlpl
def u:probe(n) {
  values = range(n);
  t0 = clock_ms();
  i = 0; total = 0;
  while 5 - i { total = total + take(values, 0, i); i = i + 1 };
  {n: n, ms: clock_ms() - t0, checksum: total}
}
```

Expected: five reads cost the same at every `n`; `checksum` is 10 throughout.

Observed: the checksum is correct, and the five reads cost 0.10 ms at
`n = 10000`, 0.38 ms at `n = 100000`, and 5.48 ms at `n = 1000000` -- linear in
the source size, consistent with copying the array per read. `demos/transducers/
transducer_cost.mlpl` prints these numbers on every run.

Fallback assessment: none preserves the complexity. Any element-at-a-time
driver -- a transducer fold, a streaming parse, a search that stops early -- is
therefore quadratic in the source size, so the demos cap their inputs at a few
thousand elements. Whole-array operations remain the only linear route, which
is exactly the composition the transducer material exists to offer an
alternative to.

Smallest upstream semantic addition: reading a single cell of an array must not
copy the source. Equivalently, an indexing form documented as O(1).

Proposed regression assertion: with `n` scaled by 100, the wall-clock cost of a
fixed number of single-element reads must not scale with `n`; a unit test can
assert the ratio stays below a small constant.

## Blocked: a fold over any callable

Minimal program:

```mlpl
def u:step(acc, x) { acc + x * x }
reduce(:u:step, [1, 2, 3])
```

Expected: `14`, by analogy with `each(:u:sq, v)` accepting a user reference.

Observed: `error: unsupported: reduce: first argument must be a builtin
reference like :add, :max, :+, :* (use the colon-prefixed form)`.

Fallback assessment: acceptable today. Every driver in
`src/transducers/core.mlpl` writes the loop by hand, which the catalog records
honestly in `explicit_loops`. The cost is interpreted per-element dispatch --
roughly 30 microseconds per element against 0.04 for whole-array arithmetic.

Smallest upstream semantic addition: `reduce(f, values, init)` where `f` is any
callable (`:u:name`, a builtin reference, or a partial), plus a `reduced(value)`
the fold honors by stopping. Together they move the per-element loop into Rust
and retire both the hand-written drivers and the `{mlpl_reduced, value}` record
convention.

Proposed regression assertion: `reduce(call(:u:map_t, :u:increment), values, 0)`
agrees with the downstream `u:transduce` result, and a fold whose step returns
`reduced(acc)` stops pulling.

## Blocker template

For each blocked row, add the smallest standalone `.mlpl` reproducer, exact
command and selected `$MLPL`, expected and observed behavior, fallback analysis,
the smallest upstream semantic addition, and a proposed regression assertion.

Do not request Ramda API parity. Express the underlying language semantic or
compiler opportunity: partial application, callable values, composition,
transduction, or allocation-visible fusion.
