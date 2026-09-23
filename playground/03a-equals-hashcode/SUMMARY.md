# 03a — equals and hashCode: the contract, and how breaking it corrupts a HashMap

## Mental model

A `HashMap` never searches. `hashCode` picks the bucket, `equals` picks the entry inside it.
If `hashCode` sends you to the wrong bucket, `equals` never even runs.

```text
get(key)
  │
  ├─ 1. key.hashCode()  → bucket index        ── wrong hash? empty bucket → null. equals never ran.
  │
  └─ 2. walk that bucket: stored.equals(key)  ── right bucket, stored key changed? equals false → null.
```

A bucket is a **list**, not a slot: two different keys with the same hash sit side by side in it.

## The contract

| Rule | Why the map needs it |
|---|---|
| `a.equals(b)` ⇒ `a.hashCode() == b.hashCode()` | equal keys must land in the same bucket, or `equals` is never asked |
| same hash does **not** imply equal | collisions are legal; `equals` sorts them out inside the bucket |
| `hashCode` stable while the object is a key | the entry stays in the bucket it was put in — it is never re-filed |

- Override **both or neither**. `equals` alone → each instance gets its identity hash → duplicates.
- Build `hashCode` from **exactly the fields `equals` uses** (`code.hashCode()`, `Objects.hash(a, b)`).

## Which method failed? (ask this every time)

| Situation | hashCode | equals | Result |
|---|---|---|---|
| `equals` overridden, `hashCode` not; add two equal objects | different buckets | **never called** | set size 2 |
| key mutated; `get(sameObject)` | new hash → empty bucket | **never called** | `null` |
| key mutated; `get(new Key(oldName))` | old hash → right bucket | **false** (stored key changed) | `null` |
| `put(k, 99)` where an equal key exists | same bucket | true | value overwritten, size unchanged |

## Renaming a key safely

```java
// take it out while the hash still matches, then put it back under the new key
stock.put(north = new Warehouse("north-2"), stock.remove(new Warehouse("north-1")));
```

Arguments evaluate left to right: the `remove` runs before the `put`. Better still, use immutable keys
so this can't happen at all.

## The traps

- The row is "still in there" (`size() == 1`) and unreachable, because `size()` counts entries and
  doesn't look them up.
- Fixing the test instead of the code: a check changed to assert the buggy value passes, and the
  bug is still there.
- `put` with the new key without `remove` of the old leaves an orphan entry nobody can reach.

## Mistakes actually made

- **Step 2, two rounds:** said "`equals` is wrong" when a mutated key missed. `equals` never ran,
  because the hash sent the probe to an empty bucket. Then called `get(new Tag("java"))` a hit. It
  was the right bucket, but the stored key had changed, so `equals` is the one that fails.
- **Step 2:** treated a bucket as one slot, and answered size 1 for two distinct equal-hash items.
  Fixed on the re-test.
- **Step 3, check A** ended up asserting `size() == 2`, the buggy value. The real fix is `hashCode`
  on `Sku`.
- **Step 3, Report B, two wrong tries:** renamed to the same name, then `put` the new key without
  removing the old one. Needed hints on left-to-right argument evaluation and on a fresh equal key
  finding the entry.
- **Step 3:** couldn't say unaided whether `Sku.equals` was called in Report A. It wasn't: different
  identity hashes put the two objects in different buckets.
- **Drill Q1:** opened with "`equals` compares values". `Object.equals` is `==`. It compares values
  only when the class overrides it.
- **Drill Q2:** called `equals` without `hashCode` "not a bug, just mini buckets". It is a bug: the
  `HashSet` keeps duplicates and `get` returns `null` for a key that is present.
