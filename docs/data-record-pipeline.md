# JSON record pipeline

The record pipeline parses a JSON quality batch, safely obtains its `scores` and
`threshold` fields, and delegates to the branching quality report:

```text
JSON text -> parse_json -> validate record fields -> partition -> summarize
```

Run `just data-record-pipeline`. Parsing failures remain `err(...)` values via
postfix `?`. Missing fields and incompatible field types are hard runtime errors,
so `u:report_from_record` uses `try/catch` to demote them into a stable Result.
The executable covers an empty batch, a boundary singleton, duplicates,
malformed JSON, a missing field, and an invalid field type.

## Representation and cost

JSON objects become records and homogeneous numeric JSON arrays become flat
numeric arrays. Parsing copies the text into typed values. The delegated quality
pipeline then eagerly materializes a mask and two partition arrays, so logical
work and intermediate storage are linear in the score count. There are zero
explicit loops in the demo.

The runtime has no safe record-membership or field-lookup builtin. Consequently,
schema validation currently uses exception control flow; see the minimized
`blockers/record_has_field.mlpl` reproducer and the upstream contract.
