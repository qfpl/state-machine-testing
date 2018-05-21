# What and why?

##

```haskell
-- Reverse is involutive
propReverse :: Property
propReverse =
  property $ do
    xs <- forAll $ Gen.list (Range.linear 0 100) Gen.alpha
    reverse (reverse xs) === xs
```

##

What about testing the properties of a whole system?

- Retrieved data matches submitted data.
- Uniqueness constraints.
- Users only see what they're supposed to.

## State machine testing!

## The Plan

- State machines
- Property based testing _for_ state machines
- Examples

