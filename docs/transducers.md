# Transducers

A transducer is a transformation step separated from both the SOURCE that
supplies elements and the REDUCING FUNCTION that consumes them. Describe the
transformation once; choose the source and the sink later.

`src/transducers/core.mlpl` implements them for sw-MLPL. `just
transducer-pipelines` runs the behavioral demo, `just transducer-cost` runs the
measured cost accounting, and `tests/test_transducers.mlpl` pins the semantics.

## Why sw-MLPL can express them

A reducing function has the shape `(accumulator, element) -> accumulator`. A
transducer is a function `(rf) -> rf`. In Clojure that inner function is a
closure over the stage's own arguments; sw-MLPL has no closures, but it has
partials, and a partial is exactly the capture a transducer needs:

```mlpl
def u:map_t(fn, rf, acc, x) { call(rf, acc, call(fn, x)) }

stage = call(:u:map_t, :u:increment)   # a PARTIAL: (rf, acc, x) outstanding
step = call(stage, :add)               # supply the rf: (acc, x) remains
```

`call` with fewer arguments than the arity returns a partial, extra arguments
apply left-associatively, and partials are ordinary values, so stages compose
with `u:comp2` and travel through records and arguments like any other data.

## What the pipelines demo proves

`demos/transducers/transducer_pipelines.mlpl` is self-checking and asserts:

- one xform runs into three sinks (collect, sum, count) with no rewrite;
- the same composed tail runs over an ARRAY source and a STRING LIST source;
- composition order is data order, so the two orders give different answers;
- an expanding stage (`u:mapcat_t`) feeds several elements downstream per input;
- a Result-returning stage stops the fold on the first `err`, carrying the
  diagnostic as the accumulator;
- `u:take_t` stops the fold after three survivors, pulling 6 of 1000 elements;
- empty and singleton sources behave.

## What the cost demo measures

`demos/transducers/transducer_cost.mlpl` reports work accounting
deterministically and prints wall-clock as informational evidence. Measured with
mlpl-repl 0.20.0 on an Apple Silicon laptop:

| n | vectorized | eager stages | transducer | transducer us/element |
|---|---|---|---|---|
| 500 | 0.05 ms | 3.0 ms | 13.9 ms | 27.9 |
| 1000 | 0.05 ms | 6.7 ms | 30.4 ms | 30.4 |
| 2000 | 0.09 ms | 19.9 ms | 70.6 ms | 35.3 |

Deterministic accounting at `n = 2000`: the eager route materializes 6000
intermediate cells, the transducer materializes 0. Stopping early, the
transducer pulls 6 elements out of 4000 where the eager route pulls all 4000.

Read the table honestly. **Transducers are not currently a wall-clock win in
sw-MLPL.** Whole-array arithmetic runs in Rust at roughly 0.04 microseconds per
element; a transducer fold runs the interpreter once per element per stage, at
roughly 30 microseconds per element. That is a factor of several hundred, and no
amount of fusion closes it. What the transducer removes is intermediate
allocation and wasted pulls, not per-element cost.

The per-element cost also GROWS with the source, which is not inherent to
transducers. The demo isolates the reason: five single-element reads of one
array cost 0.10 ms at n = 10000, 0.38 ms at n = 100000, and 5.48 ms at
n = 1000000. Reading one element copies the whole source, so any element-at-a-time
driver is quadratic. `docs/upstream-contract.md` carries this as the blocking
request.

## When a transducer is the right tool here

- The transformation must be reused across different sinks or sources.
- A stage is a user function that whole-array arithmetic cannot express.
- The fold should stop early and the source is expensive to scan.
- Intermediate arrays are the constraint rather than per-element speed.

Otherwise prefer the whole-array route: `values + 1`, `compress`, `reduce`. The
array operations are the language's fast path, and the composition-comparison
demo already shows how to keep those readable.

## Relationship to monads

A transducer is not a monad. Its type is the CPS encoding of a fold --
`forall acc. (acc -> b -> acc) -> (acc -> a -> acc)` -- and its algebra is a
MONOID: `u:comp2` is associative, and the identity transducer (`call(rf, acc, x)`
unchanged) is its unit. Composing transducers is function composition, not
sequencing effects.

The two ideas touch in three places this repository can demonstrate:

1. **The stage protocol is a Kleisli arrow of the list monad, fused.** A stage
   may call the downstream rf zero times (`u:filter_t` rejecting), once
   (`u:map_t`), or many times (`u:mapcat_t`). That is exactly the shape of a
   function `a -> [b]`, and composing stages corresponds to Kleisli composition
   of those functions -- except no intermediate list is built. `u:mapcat_t` is
   bind; a stage that always calls rf once is the lifted pure function.

2. **`reduced` is the fold's version of `err` short-circuiting.** sw-MLPL ships
   the Result monad's combinators (`map_ok`, `and_then`, `or_else`, and `?`).
   `and_then` stops threading on the first `err`; the transducer driver stops
   pulling on the first reduced accumulator. `u:validating_t` puts the two
   together: it calls a Result-returning check, passes `ok` values downstream,
   and wraps the first `err` in the reduced envelope, so a fold aborts exactly
   where a `?` chain would -- with the same diagnostic in hand.

3. **The accumulator is where the monad would keep its context.** Clojure's
   stateful stages hide their state in a closure; without closures the state
   rides in the accumulator (`u:take_t` owns the documented `{left, inner}`
   envelope). This is the state monad written out by hand: the driver threads
   `state -> (state, output)` explicitly because the language will not thread it
   implicitly.

The practical reading: monads sequence a computation that carries context;
transducers factor the transformation out of a fold. They compose with each
other -- a Result-returning stage inside a transducer pipeline is a Kleisli
arrow inside a monoid of stages -- and sw-MLPL already has enough of both to
write that down.

## Upstream requests this raises

See `docs/upstream-contract.md` for the minimized versions:

1. Constant-time single-element access (or a native fold that walks a source
   element-at-a-time in Rust). This is the blocking one; without it every
   driver here is quadratic.
2. `reduce` accepting any callable plus an initial value, so the driver is a
   builtin rather than an interpreted loop.
3. A `reduced` value the language's own fold honors, replacing the record
   envelope convention.
4. Per-instance stage state (or closures), so stateful stages stop leaking their
   state into the caller's accumulator.
