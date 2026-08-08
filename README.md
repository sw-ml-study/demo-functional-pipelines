# demo-functional-pipelines

Runnable sw-MLPL examples of readable functional pipelines. The examples take
inspiration from Ramda's emphasis on composition, while using sw-MLPL's array
operations and compiler-visible functions rather than reproducing a JavaScript API.

This repository is a downstream forcing function for
[sw-mlpl](https://github.com/sw-ml-study/sw-mlpl). Each example must be a
deterministic self-checking pipeline, an honest documented approximation, or a
minimized request in [the upstream contract](docs/upstream-contract.md).

## Start with the application

The end-to-end example evaluates binary-classifier output supplied as JSON:

```json
{"logits":[-2,0,2,1],"labels":[0,1,1,0],"threshold":0.5}
```

Install [`just`](https://just.systems/), then run:

```sh
just classifier-evaluation
```

The self-checking application parses and validates the record, converts logits
to probabilities, classifies them, and reports `tp=2`, `fp=1`, `tn=1`, `fn=0`,
accuracy `0.75`, precision `2/3`, and recall `1`. It also checks malformed JSON,
missing and mistyped fields, invalid labels and thresholds, mismatched lengths,
empty input, and the exact decision boundary.

Executable recipes use `../sw-mlpl/target/release/mlpl-repl` by default. Set
`MLPL=/absolute/path/to/mlpl-repl` to select another build.

## Explore the building blocks

- `just binary-metrics` runs the reusable numeric evaluation core.
- `just map-filter-reduce` introduces eager transformation and selection.
- `just branching-pipelines` partitions data through a bound predicate.
- `just data-record-pipeline` demonstrates a smaller fallible JSON flow.
- `just record-lookup` pins exception-free record access.
- `just composition-comparison` compares nesting, named stages, `atop`, and
  `over`.

For complete verification:

```sh
just demos
just audit
just check
```

`just demos` executes every runnable catalog row. `just audit` validates the
repository structure, catalog, documentation links, and record-lookup contract.

## Repository map

```text
catalog/demos.tsv          machine-readable demo inventory
src/evaluation/            reusable classifier-evaluation stages
demos/evaluation/          self-checking numeric and JSON applications
docs/upstream-contract.md  verified capabilities and feature-pressure template
scripts/check              pre-commit validation gate
scripts/run-all            catalog-driven demo execution
scripts/validate-catalog   catalog schema and path audit
```
