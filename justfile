set shell := ["sh", "-cu"]

default:
    @just --list

check:
    ./scripts/check

audit:
    ./scripts/validate-catalog catalog/demos.tsv
