# State machine testing

## 

- Data type to model the state we care about
- Data types for actions that transition states
- A way to execute actions and update model state
- Properties to ensure that pre and post conditions aren't violated

## Enter the hedgehog

<div class="notes">
TODO: bad photoshop of a hedgehog in Enter the dragon
</div>

## { data-background-image="images/phases.png"
      data-background-color="white"
      data-background-size="80%"
      data-background-transition="none"
    }

<div class="notes">
Same as regular property tests
</div>

##

Things to consider

- All commands _and their inputs_ are generated before execution.
- Future actions will often require outputs from earlier actions.
- Which commands are possible to run may depend on the state --- before we've produced any.
- Shrinking might remove a command whose output is required by a future command.

##

`Symbolic a` &nbsp; vs &nbsp; `Concrete a`

##

`Symbolic` is used to...

- Keep track of the values that our commands will output upon execution.
- Decide whether a command is valid during generation.
- Determine whether the command is still valid to run when shrinking.

<div class="notes">
e.g. can't run a register action without having first registered the first user

This applies to the third point too, but mentioning separately because handled
separately.
</div>

##

`Concrete` is used to...

- Replace `Symbolic` s in our state as values become known.
- Provide inputs to future commands when executing them.
- Provide values to property tests.

## Commands

Bundle together:

- Generation of inputs
- Execution of those inputs
- Callbacks used by hedgehog

##

```haskell
data Command n m state =
  Command {
      commandGen ::
        state Symbolic -> Maybe (n (input Symbolic))






    }
```

##

```haskell
data Command n m state =
  Command {
      commandGen ::
        state Symbolic -> Maybe (n (input Symbolic))

    , commandExecute ::
        input Concrete -> m output



    }
```

##

```haskell
data Command n m state =
  Command {
      commandGen ::
        state Symbolic -> Maybe (n (input Symbolic))

    , commandExecute ::
        input Concrete -> m output

    , commandCallbacks ::
        [Callback input output state]
    }
```

## Callbacks

Are one of:

- Precondition to check that an action is still valid when shrinking.
- State update --- used for both generation and execution.
- Postcondition that checks properties hold after execution

##

```haskell
data Callback input output state =
    Require ( state Symbolic
              -> input Symbolic
              -> Bool)











```

##

```haskell
data Callback input output state =
    Require ( state Symbolic
              -> input Symbolic
              -> Bool)
  | Update ( forall v. Ord1 v
             => state v
             -> input v
             -> Var output v
             -> state v)






```

##

```haskell
data Callback input output state =
    Require ( state Symbolic
              -> input Symbolic
              -> Bool)
  | Update ( forall v. Ord1 v
             => state v
             -> input v
             -> Var output v
             -> state v)
  | Ensure ( state Concrete
             -> state Concrete
             -> input Concrete
             -> output
             -> Test ())
```

## Putting it all together

##

```haskell
propRegisterFirst :: ClientEnv -> IO () -> TestTree
propRegisterFirst env reset =
  testProperty "register-first" . property $ do
    let
      initialState = SimpleState False
      cs = [ cRegisterFirst env
                , cRegisterFirstForbidden env]
    actions <- forAll $
      Gen.sequential (Range.linear 1 100) initialState cs

    test $ do
      liftIO reset
      executeSequential initialState actions
```

