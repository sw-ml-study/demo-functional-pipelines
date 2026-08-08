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
recipes use `../sw-mlpl/target/debug/mlpl-repl` by default; set
`MLPL=/absolute/path/to/mlpl-repl` to select another build.

Start with `just map-filter-reduce`, which demonstrates eager mapping,
predicate selection, and reduction with explicit empty-input behavior.
Then run `just branching-pipelines` for callable partial application, immutable
partition branches, shared summarization, and Result-valued validation.

## Repository map

```text
catalog/demos.tsv          machine-readable demo inventory
docs/upstream-contract.md  minimized language needs and available fallbacks
scripts/check              pre-commit validation gate
scripts/validate-catalog   catalog schema and path audit
```
