set shell := ["sh", "-cu"]

default:
    @just --list

check:
    ./scripts/check

audit:
    ./scripts/audit-repository
    ./scripts/validate-catalog catalog/demos.tsv
    ./scripts/test-record-lookup

# Run native mlplunit tests; extra arguments are forwarded to mlplunit.
tests *args:
    ./scripts/run-tests {{args}}

# Run native tests with TAP reporting.
tap *args:
    ./scripts/run-tests --format tap {{args}}

# List tests discovered by mlplunit.
list-tests:
    ./scripts/run-tests --list

demos:
    ./scripts/run-all

map-filter-reduce:
    ./scripts/run-map-filter-reduce

branching-pipelines:
    ./scripts/run-branching-pipelines

data-record-pipeline:
    ./scripts/run-data-record-pipeline

record-lookup:
    ./scripts/test-record-lookup

composition-comparison:
    ./scripts/run-composition-comparison

binary-metrics:
    ./scripts/run-binary-metrics

classifier-evaluation:
    ./scripts/run-classifier-evaluation
