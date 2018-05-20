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

- Inputs match outputs.
- Can't add users with the same email.
- Can't access protected content without a token.

## State machine testing!

## The Plan

- State machines
- Property based testing _for_ state machines
- Examples

## The not-plan

- Servant
- Details of property based testing or hedgehog
- Details of test infrastructure

<div class="notes">
- Servant is incidental, but has a benefit to testing.
- Assume you're familiar with the basic concept of property testing and hedgehog.
- Watch Jacob's outstanding talk from last year.
- Test infrastructure refers to all the code that sets up the database, runs the app, etc.
- All code is up on github, so you feel free to take a look and find me on the internet if you have questions.
</div>
