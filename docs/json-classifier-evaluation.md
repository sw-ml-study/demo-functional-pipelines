# JSON classifier evaluation application

The application accepts a JSON record with three required fields:

```json
{"logits":[-2,0,2,1],"labels":[0,1,1,0],"threshold":0.5}
```

Its full functional flow is:

```text
JSON -> parse -> safe field lookup -> domain validation
     -> sigmoid -> threshold -> confusion counts -> metrics report
```

Run `just classifier-evaluation`. The realistic sample produces `tp=2`,
`fp=1`, `tn=1`, `fn=0`, accuracy `0.75`, precision `2/3`, and recall `1`.

Parsing and missing-field failures stay Result values. Missing fields preserve
the structured `missing_field` payload from `record_get`. Wrong JSON field kinds
are caught at the schema boundary and become one stable domain error. Numeric
shape, label, and threshold errors come unchanged from the reusable core.

The self-checking application covers a valid batch, empty batch, exact decision
boundary, malformed JSON, every missing required field, mismatched lengths,
non-binary labels, an invalid threshold, and wrong kinds for all three fields.

Parsing allocates typed record and array values. Evaluation then eagerly
materializes probabilities, predictions, and masks. Logical work and temporary
storage are linear in the batch size; there are zero explicit loops in the
application source.
