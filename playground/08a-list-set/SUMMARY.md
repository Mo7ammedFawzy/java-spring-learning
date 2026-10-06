# 08a — List and Set: the backing structure decides the cost

**Mental model:** The interface is the promise, the backing structure is the price.

**Key rule:** Big O states how the work grows with `n`, constants dropped.

| | Backing | `get(i)` | add at end | front / middle | `contains` | Order |
|---|---|---|---|---|---|---|
| `ArrayList` | array | O(1) | O(1) amortised | O(n) shift | O(n) | insertion |
| `LinkedList` | linked nodes | O(n) walk | O(1) | front O(1); middle O(n) walk | O(n) | insertion |
| `HashSet` | hash table | no index | O(1) | no position | O(1) | none promised |
| `LinkedHashSet` | hash table + links | no index | O(1) | no position | O(1) | insertion |
| `TreeSet` | red-black tree | no index | O(log n) | no position | O(log n) | sorted |

**Classic trap:**

```java
for (int i = 0; i < list.size(); i++) total += list.get(i);   // list is a LinkedList
```

Right result, O(n²): every `get(i)` walks again from the nearer end. A for-each uses the
iterator, which remembers its position, so the same loop is O(n).

**Interview answer (30 s):** `ArrayList` is an array, so reading by index is O(1) and inserting at
the front or middle shifts elements, O(n). `LinkedList` is nodes, so it inserts in O(1) only where it
already is — the two ends, or at an iterator — and reaching any other position costs O(n). That is
why `ArrayList` is the default. A `Set` forbids duplicates; `HashSet` gives O(1) with no order,
`LinkedHashSet` adds insertion order at the same cost, `TreeSet` is sorted at O(log n).

**My mistake:**
- Read `LinkedHashSet` as a `LinkedList` ("fast insertion, slow read") → "Linked" there buys
  insertion order, not a different cost. It is still a hash table.
- Said `contains` on a hash set is O(1) because "it walks and reads" → it is O(1) because it does
  not walk: the hash jumps to the bucket.
- Predicted a `HashSet`'s print order → no order is promised; it follows the hashes.
- Fixed the slow loop by copying into an `ArrayList` → works, but a for-each needs no copy.
