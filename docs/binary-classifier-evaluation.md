# Binary classifier evaluation

The evaluation application turns model logits and ground-truth labels into a
metrics report through reusable pure stages:

```text
logits -> sigmoid -> inclusive threshold -> predictions
labels + predictions -> confusion counts -> accuracy / precision / recall
```

Run `just binary-metrics`. The executable covers empty input, positive and
negative singletons, an exact-threshold prediction, duplicates, all-positive
predictions, all-negative predictions, mismatched shapes, invalid labels, and
an invalid threshold.

## Contract and conventions

- Logits and labels are same-shaped flat numeric arrays.
- Labels are exactly `0` or `1`.
- The probability threshold is inclusive and lies in `[0,1]`.
- Confusion counts use `{tp, fp, tn, fn}`.
- Precision or recall with a zero denominator is reported as `0`.
- Empty evaluation produces zero counts and zero metrics.

## Representation and cost

sw-MLPL eagerly materializes probabilities, predictions, and temporary masks.
For `n` examples, logical work and intermediate storage are linear. The source
contains zero explicit loops; pervasive arithmetic and reductions expose the
array-wide stages. This demo measures correctness, not elapsed performance or
allocation fusion.
