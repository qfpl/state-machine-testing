# State machine testing

## Big picture

- Use a state machine to model an app.
- Randomly generate inputs.
- Execute inputs against the app and update the model.
- Check that the model agrees with reality.

## Enter the hedgehog

## State

```haskell
data ModelState (v :: * -> *) =
  ModelState Bool
```

## Inputs

```haskell
data ModelInput1 (v :: * -> *) =
  ModelInput1 Parameter1 Parameter2

data ModelInput2 (v :: * -> *) =
  ModelInput2 Parameter3 Parameter4
```

<div class="notes">
- Recommend one type per input/expected output pair
- Often correspond to endpoints in web app
- No restrictions on inputs
  + Multiple inputs for the one endpoint
  + Don't have to correspond to an endpoint
</div>

## Initial state

```haskell
initialState :: ModelState v
initialState = ModelState False
```

## { data-background-image="images/phases.png"
      data-background-color="white"
      data-background-size="80%"
      data-background-transition="none"
    }

<div class="notes">
We have a model, but we need a way to use that model to do our testing
- Generation of inputs
- Execution of inputs 
- Callbacks used by hedgehog
</div>

## State -> complexity

- Commands and inputs generated before execution.
- Future inputs depend on past outputs.
- Validity of commands depends on state.
- Shrinking might break dependencies.

<div class="notes">
- We need a way of talking about outputs _before_ we've executed anything
</div>

## Solution

`Symbolic a` &nbsp; and &nbsp; `Concrete a`

## Commands

##

```haskell
data Command n m state =
  Command {
      commandGen ::
        state Symbolic -> Maybe (n (input Symbolic))






    }
```

<div class="notes">
In all our code, `n` is an instance of `MonadGen`
`m` is the monad in which our tests are run and output generated
</div>

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

##

```haskell
data Callback input output state =
    Require ( state Symbolic
              -> input Symbolic
              -> Bool)











```

<div class="notes">
Check that we're still in a state that allows us to run a command.
</div>

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

## HTraversable

```haskell
class HTraversable t where
  htraverse
    :: Applicative f
    => (forall a. g a -> f (h a)) -> t g -> f (t h)
```

<div class="notes">
Docs describe it as "higher order traversable functors"
</div>

##

```haskell
(            a -> f b)     -> t a -> f (t b)

(forall a. g a -> f (h a)) -> t g -> f (t h)
```

##

```haskell

htraverse
  :: (forall a. Symbolic a -> Either e (Concrete a))
  -> t Symbolic
  -> Either e (t Concrete)
```

##

```haskell
data ModelInput1 (v :: * -> *) =
  ModelInput1 Parameter1 Parameter2

data ModelInput2 (v :: * -> *) =
  ModelInput2 Parameter3 Parameter4
```

