# compimp

project for addressing runek's comment:

```Also, anyone care to produce some benchmarks comparing the imperative Python/Haskell quicksort implementations? They look so similar, it'd be quite interesting to see how well GHC can optimize this sort of stuff.
```

from:

https://news.ycombinator.com/item?id=14448056

re

http://vaibhavsagar.com/blog/2017/05/29/imperative-haskell/

## Python

In `qs.py`.

## Haskell

In `src/QS.hs`.

    λ> :set +s
    λ> runQS
    Results: [24983128,24715277,21087377]
    (127.64 secs, 104,680,561,000 bytes)
