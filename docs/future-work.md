# Future work

The repository has a complete functional-pipeline foundation and a realistic
JSON binary-classifier evaluation application. Every runnable entry is selected
from `catalog/demos.tsv`, executed by `just demos`, and covered by `just check`.
This document records what remains without treating every interesting idea as a
current blocker.

## Priority order

| Priority | Work | Status | Dependency |
|---|---|---|---|
| 1 | Collection-oriented application | unblocked | shipped array, record, sorting, and selection operations |
| 2 | Result-composition application | unblocked | `map_ok`, `and_then`, `or_else`, `record_get`, and `?` |
| 3 | Expand mlplunit coverage | partially delivered | compatible mlplunit installation or checkout |
| 4 | Functional record updates and lenses | conditional | audit shipped sw-MLPL record/lens semantics first |
| 5 | Allocation and fusion evidence | partially unblocked | reproducible measurement design; compiler telemetry may require upstream work |
| 6 | Catalog and documentation maturity | unblocked | existing validation scripts |

## 1. Collection-oriented application

Motivation: the current classifier application transforms parallel numeric
arrays, but a broader functional-programming demonstration should also show how
collections are grouped, indexed, sorted, deduplicated, and summarized.

Current baseline: `compress`, `grade_up`, `grade_down`, `gather_rows`, records,
and deterministic reductions are available. The repository does not yet combine
them into one realistic collection workflow.

Acceptance criteria:

- Choose a concrete domain such as ranked experiment results, transaction
  batches, or model-candidate selection.
- Parse or construct one deterministic dataset and preserve companion columns
  through every reorder or selection.
- Demonstrate at least grouping or indexing, stable sorting, deduplication, and
  multi-field aggregation.
- Cover empty, singleton, duplicate-key, tie, invalid, and boundary inputs.
- Document representation invariants and distinguish logical work from eager
  copies.
- Register the application in the catalog and complete it through `just check`.

Blocker status: none confirmed. Minimize any discovered representation gap in
`docs/upstream-contract.md` before requesting an sw-MLPL change.

## 2. Result-composition application

Motivation: current JSON flows use `?` effectively, but do not teach a complete
railway with transformation, dependent validation, and recovery alternatives.

Current baseline: `parse_json`, `record_get`, `map_ok`, `and_then`, `or_else`,
and postfix `?` are shipped. Missing fields already remain structured Result
data.

Acceptance criteria:

- Build three independently reusable fallible stages.
- Show `map_ok` for a pure transformation, `and_then` for dependent validation,
  and `or_else` for an explicit recovery policy.
- Prove the first error is preserved unless recovery is deliberately selected.
- Cover success, failure at each stage, recovery success, and recovery failure.
- Compare the railway with a named imperative-looking equivalent without
  claiming that one changes runtime allocation behavior.

Blocker status: none confirmed.

## 3. Expand mlplunit coverage

Motivation: demos remain self-checking in their final Result, while reusable
source behavior benefits from mlplunit's named discovery, isolation, selection,
and machine-readable test output.

Current baseline: adoption is complete. The root `mlplunit.conf`,
`scripts/run-tests`, and thin `just tests`, `just tap`, and `just list-tests`
recipes provide native reporting. `tests/test_record_lookup.mlpl` contains five
named tests, and `just check` runs the suite in TAP mode alongside every
standalone demo.

Acceptance criteria:

- Provide named tests for each reusable source module and keep narrated demos
  self-checking.
- Add a catalog or structural check proving every reusable source module has
  registered native coverage.
- Prefer parameterized `@cases` when future behavior has a natural input/output
  table.

Blocker status: no sw-MLPL blocker is known. The remaining work is incremental
coverage, not test-runner adoption.

## 4. Functional record updates and lenses

Motivation: safe record reads are covered, but functional pipelines also benefit
from immutable nested updates and reusable field-focused transformations.

Current baseline: records, `has_field`, and Result-valued `record_get` provide
safe access. This repository has not verified the current functional-lens or
record-update surface against the deployed binary.

Acceptance criteria:

- Audit current sw-MLPL documentation and executable behavior before designing
  downstream syntax.
- Demonstrate immutable get, set, and transform operations on nested records.
- Prove the original record remains unchanged.
- Compose at least two field paths and preserve structured missing-path errors.
- Record eager copy behavior; do not claim structural sharing without physical
  evidence.

Blocker status: conditional. If shipped semantics cannot express safe immutable
updates, add a minimal executable reproducer and request the smallest semantic
addition upstream. A Ramda-compatible API name is not itself a requirement.

## 5. Allocation, timing, and fusion evidence

Motivation: the examples expose compiler-visible stages, but currently make only
logical complexity and eager-intermediate claims. They do not demonstrate
allocation elimination or fused execution.

Current baseline: deterministic workloads and catalog execution exist.
sw-MLPL exposes monotonic timing, while direct allocation/fusion telemetry has
not been verified for this repository.

Acceptance criteria:

- Define identical workloads for nested, named, and immediate composition.
- Separate logical element visits, elapsed timing, and allocation measurements.
- Warm and batch timing runs and record the selected binary build and workload
  metadata.
- Never infer fusion from elapsed time alone.
- If compiler IR or allocation counters are unavailable, document the exact
  observation needed and provide a minimized upstream request.

Blocker status: timing experiments are unblocked. Claims about fusion or
allocation elimination are blocked until direct evidence is available.

## 6. Catalog and documentation maturity

Motivation: the catalog drives execution, but its metadata is intentionally
small and does not yet describe inputs, expected output schemas, or source/test
relationships.

Current baseline: catalog schema, runnable paths, shell syntax, documentation
links, task-runner policy, record lookup, and every demo are checked locally.

Acceptance criteria:

- Decide whether input schema, output schema, source module, test path, and
  maturity belong in the catalog or a companion table.
- Mechanically validate every added field rather than treating metadata as prose.
- Keep README commands and catalog identifiers synchronized.
- Add concise contributor guidance for creating one source/demo/test/doc slice.
- Retain `just` as the only task runner and keep recipes thin.

Blocker status: none.

## Conditional language opportunities

These are exploration boundaries, not active blockers:

- A reusable variadic `pipe` value is not currently demonstrated. Named UDFs,
  partials, `atop`, and `over` cover the existing applications.
- Heterogeneous arrays of callable values are not required; records can hold
  named callable registries.
- Streaming, transducers, lazy evaluation, structural sharing, and compiler
  fusion must not be claimed without shipped semantics and executable evidence.
- Domain-specific schema validation remains downstream work even though
  `record_get` makes field presence exception-free.

## Tooling limitation

`agentrail audit` matches implementation commits to saga steps but reports the
required post-completion metadata commits, plus the repository's initial commit,
as orphans. The current CLI has no supported command to attach those commits to
completed steps. Creating fake pending steps would make the durable saga record
less accurate. This is an AgentRail bookkeeping limitation, not a sw-MLPL or
demo-runtime blocker.

## Non-goals

- Reproduce the complete Ramda API or JavaScript calling conventions.
- Claim superiority over Python, NumPy, JAX, or established functional languages.
- Hide eager copies behind functional terminology.
- Add a Makefile alongside the repository `justfile`.
- Modify `../sw-mlpl` from a downstream demo feature step.
