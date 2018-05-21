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
  let
    t = clientToken pwr
  in
    evalEither =<< successClient env (me t)
```

##

```haskell
cMeCallbacks
  :: [Callback Me Player LeaderboardState]
cMeCallbacks = [
    Require $ \(LeaderboardState ps _) (Me PlayerWithRsp{..}) ->
      M.member _pwrEmail ps
  , Require $ \(LeaderboardState _ as) _ ->
      not (null as)
  , Ensure $ \(LeaderboardState ps _) _ _ p@Player{..} -> do
      pwr@PlayerWithRsp{..} <- eval (ps M.! _playerEmail)
      let
        -- If there's only one user it should be an admin regardless of what we input
        pwrAdmin = fromMaybe False _pwrIsAdmin
      annotateShow $ length ps
      annotateShow pwr
      annotateShow p
      (_rspId . concrete $ _pwrRsp) === LS.PlayerId _playerId
      _pwrUsername === _playerUsername
      _pwrEmail === _playerEmail
      pwrAdmin === _playerIsAdmin
 ]
```
