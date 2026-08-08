# Map, filter, reduce

The first pipeline doubles every input, keeps doubled values greater than or
equal to six, and sums the survivors:

```text
values -> each(double) -> compress(at-least-six) -> reduce(add)
```

Run it with `just map-filter-reduce`. The executable checks empty input, a
filtered singleton, the inclusive boundary, negative values, and duplicates.

## Representation and cost

sw-MLPL arrays are eager values. This implementation materializes the mapped
array and the selected array before reduction. For `n` inputs it performs
linear logical work and uses linear intermediate storage. It has zero explicit
loops in demo code: `each`, vectorized comparison, `compress`, and `reduce`
express the traversal boundaries to the runtime.

This is composition through a named UDF and explicit intermediate values. It
does not claim lazy streaming, transducer fusion, or allocation elimination.
