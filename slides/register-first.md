# Example1: counting registrations

## State

```haskell
newtype LeaderboardState (v :: * -> *) =
  LeaderboardState Int
```

<div class="notes">
`v` parameter for `Symbolic` or `Concrete` --- will explain more later
</div>

## Actions

```haskell
newtype RegFirst (v :: * -> *) =
    RegFirst RegisterPlayer

newtype RegFirstForbidden (v :: * -> *) =
  RegFirstForbidden RegisterPlayer
```

##

```haskell
registerFirst  :: RegisterPlayer -> ClientM ResponsePlayer
```

## Commands

