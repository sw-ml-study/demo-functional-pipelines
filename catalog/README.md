# Demo catalog

`demos.tsv` is the executable inventory. Its tab-separated columns are `id`,
`path`, `concept`, `dynamic_size` (`yes` or `no`), `explicit_loops`,
`required_features`, and `status` (`runnable` or `gated`).

A runnable row must point to a file. A gated row may point to a proposed path,
but its unmet need must have a matching entry in `docs/upstream-contract.md`.
