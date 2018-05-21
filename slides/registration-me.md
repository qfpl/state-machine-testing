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
    \(LeaderboardState ps _) _ _ p@Player{..} -> do
      pwr@PlayerWithRsp{..} <- eval (ps M.! _playerEmail)






  ]
```

##

```haskell
cMeCallbacks =
  [ Require $ \(LeaderboardState ps _) (Me p) ->
      M.member (_pwrEmail p) ps
  , Ensure $
    \(LeaderboardState ps _) _ _ p@Player{..} -> do
      pwr@PlayerWithRsp{..} <- eval (ps M.! _playerEmail)
      let
        pwrAdmin = fromMaybe False _pwrIsAdmin




  ]
```

##

```haskell
cMeCallbacks =
  [ Require $ \(LeaderboardState ps _) (Me p) ->
      M.member (_pwrEmail p) ps
  , Ensure $
    \(LeaderboardState ps _) _ _ p@Player{..} -> do
      pwr@PlayerWithRsp{..} <- eval (ps M.! _playerEmail)
      let
        pwrAdmin = fromMaybe False _pwrIsAdmin
      _rspId (concrete _pwrRsp) === LS.PlayerId _playerId
      _pwrUsername === _playerUsername
      _pwrEmail === _playerEmail
      pwrAdmin === _playerIsAdmin
  ]
```

## TODO

- run this test
- See it fail
- update the generation for RegFirst
- see that it fixed it


