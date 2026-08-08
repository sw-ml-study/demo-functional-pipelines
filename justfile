set shell := ["sh", "-cu"]

default:
    @just --list

check:
    ./scripts/check

audit:
    ./scripts/validate-catalog catalog/demos.tsv

map-filter-reduce:
    ./scripts/run-map-filter-reduce

branching-pipelines:
    ./scripts/run-branching-pipelines

data-record-pipeline:
    ./scripts/run-data-record-pipeline

upstream-blockers:
    ./scripts/check-upstream-blockers
