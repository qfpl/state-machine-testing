# Example 3: round trip

## Property

Data retrieved for a player matches data entered

## `cMe`

```haskell
cMe
  :: ( MonadGen n
     , MonadTest m
     , MonadIO m
     )
  => ClientEnv
  -> Command n m LeaderboardState
cMe env =
    Command cMeGen (cMeExecute env) cMeCallbacks
```

##

```haskell
cMeGen
  :: MonadGen n
  => LeaderboardState Symbolic
  -> Maybe (n (Me Symbolic))
cMeGen (LeaderboardState ps _) =
  fmap Me <$> genPlayerWithRsp ps
```

##

```haskell
cMeExecute
  :: ( MonadIO m
     , MonadTest m
     )
  => ClientEnv
  -> Me Concrete
  -> m Player
cMeExecute env (Me pwr) =
  evalEither =<< successClient env (me (clientToken pwr))
```

##

```haskell
cMeCallbacks =
  [ Require $ \(LeaderboardState ps _) (Me p) ->
      M.member (_pwrEmail p) ps









  ]
```

##

```haskell
cMeCallbacks =
  [ Require $ \(LeaderboardState ps _) (Me p) ->
      M.member (_pwrEmail p) ps
  , Ensure $
    \(LeaderboardState ps _) _ _ Player{..} -> do
      PlayerWithRsp{..} <- eval (ps M.! _playerEmail)






  ]
```

##

```haskell
cMeCallbacks =
  [ Require $ \(LeaderboardState ps _) (Me p) ->
      M.member (_pwrEmail p) ps
  , Ensure $
    \(LeaderboardState ps _) _ _ Player{..} -> do
      PlayerWithRsp{..} <- eval (ps M.! _playerEmail)
      let
        pwrAdmin = fromMaybe True _pwrIsAdmin




  ]
```

##

```haskell
cMeCallbacks =
  [ Require $ \(LeaderboardState ps _) (Me p) ->
      M.member (_pwrEmail p) ps
  , Ensure $
    \(LeaderboardState ps _) _ _ Player{..} -> do
      PlayerWithRsp{..} <- eval (ps M.! _playerEmail)
      let
        pwrAdmin = fromMaybe True _pwrIsAdmin
      _rspId (concrete _pwrRsp) === LS.PlayerId _playerId
      _pwrUsername === _playerUsername
      _pwrEmail === _playerEmail
      pwrAdmin === _playerIsAdmin
  ]
```

## { data-background-image="images/hedgehog-failing.gif"
      data-background-transition="none"
    }

## { data-background-image="images/reg-me-fail.png"
      data-background-size="80%"
      data-background-transition="none"
    }

## { data-background-image="images/reg-me-fail-cmds.png"
      data-background-size="contain"
      data-background-transition="none"
    }

##

```haskell
cMeCallbacks =
  [ Require $ \(LeaderboardState ps _) (Me p) ->
      M.member (_pwrEmail p) ps
  , Ensure $
    \(LeaderboardState ps _) _ _ p@Player{..} -> do
      pwr@PlayerWithRsp{..} <- eval (ps M.! _playerEmail)
      let
        pwrAdmin = fromMaybe True _pwrIsAdmin
      _rspId (concrete _pwrRsp) === LS.PlayerId _playerId
      _pwrUsername === _playerUsername
      _pwrEmail === _playerEmail
      pwrAdmin === _playerIsAdmin
  ]
```

##

```haskell
cMeCallbacks =
  [





        pwrAdmin = fromMaybe True _pwrIsAdmin




  ]
```

##

```haskell
cMeCallbacks =
  [





        pwrAdmin = fromMaybe False _pwrIsAdmin




  ]
```

## { data-background-image="images/hedgehog-running.gif"
      data-background-transition="none"
    }

## { data-background-image="images/reg-me-success.png"
      data-background-size="80%"
      data-background-transition="none"
    }

