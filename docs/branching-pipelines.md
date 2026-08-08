# Branching and convergence

The quality-report pipeline validates scores, binds an inclusive threshold to a
two-argument predicate, partitions the scores, and applies the same summarizer
to both branches:

```text
                         -> compress(mask)     -> summarize -> accepted
scores -> validate -> mask
                         -> compress(1 - mask) -> summarize -> rejected
```

`call(:u:at_least, threshold)` produces a callable partial. `each` applies that
bound predicate across the scores. Both branches then converge through
`u:summarize_scores` into one immutable record-valued Result.

Run `just branching-pipelines`. The executable checks empty input, below-boundary
and boundary singletons, duplicates, an invalid threshold, and an invalid score.

## Representation and cost

Validation, mask construction, both compressions, and both summaries perform
linear logical work. The eager runtime materializes the mask and both partition
arrays, requiring linear intermediate storage. The demo contains zero explicit
loops. It does not claim shared views, lazy branches, single-pass partitioning,
or fusion.
