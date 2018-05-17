# Example 2: Player count

##

Why the `(v :: * -> *)` type parameter?

<div class="notes">
YET TO BE CONFIRMED
- A `Symbolic` and `Concrete` state are kept --- symbolic for generating inputs,
  and a concrete one to provide the actual values to inputs.
- Need HTraversable instance to change inputs from symbolic to concrete, but
  states are never swapped --- both update independently. This is why `Update`
  needs to be polymorphic.
</div>

