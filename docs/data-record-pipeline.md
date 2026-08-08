# JSON record pipeline

The record pipeline parses a JSON quality batch, safely obtains its `scores` and
`threshold` fields, and delegates to the branching quality report:

```text
JSON text -> parse_json -> validate record fields -> partition -> summarize
```

Run `just data-record-pipeline`. Parsing failures and missing fields remain
`err(...)` values through `parse_json(...)?` and `record_get(...)?`. Retrieved
values can still have incompatible domain types, so `u:report_from_record` uses
`try/catch` only to demote those numeric-operation errors into a stable Result.
The executable covers an empty batch, a boundary singleton, duplicates,
malformed JSON, a missing field, and an invalid field type.

## Representation and cost

JSON objects become records and homogeneous numeric JSON arrays become flat
numeric arrays. Parsing copies the text into typed values. The delegated quality
pipeline then eagerly materializes a mask and two partition arrays, so logical
work and intermediate storage are linear in the score count. There are zero
explicit loops in the demo.

`has_field` and `record_get` provide exception-free schema access. See
`tests/test_record_lookup.mlpl` for the executable downstream acceptance
contract and named mlplunit reporting.
