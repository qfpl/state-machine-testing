# State machine testing

## Big picture

- Use a state machine to model an app.
- Randomly generate inputs.
- Execute inputs against the app.
- Update the model.
- Check that the model agrees with reality.

## { data-background-image="images/enter-the-hedgehog.jpg" }

## State

```haskell
data LeaderboardState (v :: * -> *) =
  LeaderboardState Bool
```

## Inputs

```haskell
data PlayerCount (v :: * -> *) =
  PlayerCount
  
data RegisterFirst (v :: * -> *) =
  RegisterFirst Registration

data Register (v :: * -> *) =
  Register AdminToken Registration
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
initialState :: LeaderboardState v
initialState = LeaderboardState False
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

## Something to consider

##

All inputs are generated before execution.

```haskell



```

##

All inputs are generated before execution.

```haskell
token1 <- RegisterFirst registration1


```

##

All inputs are generated before execution.

```haskell
token1 <- RegisterFirst registration1
token2 <- Register token1 registration2
```

<!--
##

Validity of inputs depends on state.

```haskell



```

##

Validity of inputs depends on state.

```haskell
put "count" $ PlayerCount
put "token1" $ Register (get "???") registration2
```

##

Shrinking might break dependencies.

```haskell
put "token1" $ RegisterFirst registration1
put "token2" $ Register (get "token1") registration2
put "count" $ PlayerCount
put "token3" $ Register (get "token1") registration3
put "token4" $ Register (get "token2") registration4
```

##

Shrinking might break dependencies.

```haskell
put "token1" $ RegisterFirst registration1
-- put "token2" $ Register (get "token1") registration2
put "count" $ PlayerCount
put "token3" $ Register (get "token1") registration3
put "token4" $ Register (get "token2") registration4
```

##

Shrinking might break dependencies.

```haskell

-- put "token2" $ Register (get "token1") registration2


put "token4" $ Register (get "token2") registration4
```

-->

## Solution

```haskell
data Var a v







```

## Solution

```haskell
data Var a v

Var a Symbolic
Var a Concrete




```

## Solution

```haskell
data Var a v

Var a Symbolic
Var a Concrete

Symbolic :: * -> *
Concrete :: * -> *
```

## Commands

Bundle together:

- Generation of an input.
- Execution of an input.
- Preconditions.
- State updates.
- Postconditions / assertions.

##

```haskell
data Command n m state =
  forall input output.
  Command {








  }
```

##

```haskell
data Command n m state =
  forall input output.
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
  forall input output.
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
  forall input output.
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
(            a -> f b    ) -> t a -> f (t b)

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
data PlayerCount (v :: * -> *) =
  PlayerCount
  
data RegisterFirst (v :: * -> *) =
  RegisterFirst Registration

data Register (v :: * -> *) =
  Register AdminToken Registration
```

