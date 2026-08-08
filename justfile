set shell := ["sh", "-cu"]

default:
    @just --list

check:
    ./scripts/check

audit:
    ./scripts/audit-repository
    ./scripts/validate-catalog catalog/demos.tsv
    ./scripts/test-record-lookup

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
