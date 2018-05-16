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

## Example1: counting registrations

## State

##

```haskell
newtype LeaderboardState (v :: * -> *) =
  LeaderboardState Int
```

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

## Actions

##

```haskell
newtype RegFirst (v :: * -> *) =
    RegFirst RegisterPlayer

newtype RegFirstForbidden (v :: * -> *) =
  RegFirstForbidden RegisterPlayer
```

```haskell
data RegisterFirst = RegisterFirst RegisterPlayer
data Register = Register RegisterPlayer
data Me = Me
data Count = Count
```

##

```haskell
register       :: SAC.Token -> RegisterPlayer -> ClientM ResponsePlayer
registerFirst  :: RegisterPlayer -> ClientM ResponsePlayer
me             :: SAC.Token -> ClientM Player
getPlayerCount :: ClientM PlayerCount
```
