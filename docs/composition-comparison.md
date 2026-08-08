# Composition styles

`just composition-comparison` proves three spellings of the same transformation
agree for empty, singleton, boundary, negative, and duplicate-bearing inputs.

## Direct nesting

```text
sum_or_zero(select_at_least_six(map_double(values)))
```

Evaluation proceeds from the innermost call outward. This is compact, but stage
names and intermediate values are harder to inspect in a longer pipeline.

## Named pipeline

`u:double_select_sum(values)` names each intermediate stage. This is the most
direct debugging and teaching form because `mapped` and `selected` identify the
dataflow explicitly.

## Immediate composition

`atop(:u:select_sum, :u:map_double, values)` evaluates the same outer-after-inner
composition immediately. `over` extends that idea to two inputs; the executable
also proves that transforming two score arrays and combining their totals yields
the same branch result.

## Runtime boundary

All three forms are eager and materialize the mapped and selected arrays. The
spellings change composition structure, not allocation or logical complexity:
each remains linear in input size with linear intermediate storage and zero
explicit demo loops.

sw-MLPL callable partials can package fixed-arity compositions, and named UDFs
can package pipelines of any chosen length. It does not represent a Ramda-style
variadic `pipe([f, g, h, ...])` as a heterogeneous function array. That API is
not required here, and this demo does not imply it exists.
