# demo-funtional-pipelines

Runnable sw-MLPL examples of readable functional pipelines. The examples take
inspiration from Ramda's emphasis on composition, while using sw-MLPL's array
operations and compiler-visible functions rather than reproducing a JavaScript API.

This repository is a downstream forcing function for
[sw-mlpl](https://github.com/sw-ml-study/sw-mlpl). Each example must be a
deterministic self-checking pipeline, an honest documented approximation, or a
minimized request in [the upstream contract](docs/upstream-contract.md).

## Run and verify

Install [`just`](https://just.systems/), then run `just check`. Executable
recipes use `../sw-mlpl/target/release/mlpl-repl` by default; set
`MLPL=/absolute/path/to/mlpl-repl` to select another build.

`just demos` executes every runnable catalog row. `just audit` validates the
repository structure, catalog, documentation links, and record-lookup contract.

Start with `just map-filter-reduce`, which demonstrates eager mapping,
predicate selection, and reduction with explicit empty-input behavior.
Then run `just branching-pipelines` for callable partial application, immutable
partition branches, shared summarization, and Result-valued validation.
`just data-record-pipeline` adds fallible JSON parsing and record validation.
`just record-lookup` pins exception-free `has_field` and `record_get` behavior.
`just composition-comparison` contrasts nesting, named stages, `atop`, and
`over` while checking that the results agree.
`just binary-metrics` runs the numeric core of a realistic binary-classifier
evaluation application from logits through confusion counts and metrics.
`just classifier-evaluation` runs the complete fallible JSON application.

## Repository map

```text
catalog/demos.tsv          machine-readable demo inventory
docs/upstream-contract.md  minimized language needs and available fallbacks
scripts/check              pre-commit validation gate
scripts/run-all            catalog-driven demo execution
scripts/validate-catalog   catalog schema and path audit
```
