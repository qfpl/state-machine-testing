# Example1: register-first

## Property:

Registering our first player only succeeds once

## State

```haskell
newtype SimpleState (v :: * -> *) =
  SimpleState Bool
```

## Inputs

```haskell
newtype RegFirst (v :: * -> *) =
    RegFirst RegisterPlayer
  deriving (Eq, Show)










```

## Inputs

```haskell
newtype RegFirst (v :: * -> *) =
    RegFirst RegisterPlayer
  deriving (Eq, Show)
instance HTraversable RegFirst where
  htraverse _ (RegFirst rp) = pure (RegFirst rp)








```

## Inputs

```haskell
newtype RegFirst (v :: * -> *) =
    RegFirst RegisterPlayer
  deriving (Eq, Show)
instance HTraversable RegFirst where
  htraverse _ (RegFirst rp) = pure (RegFirst rp)

newtype RegFirstForbidden (v :: * -> *) =
  RegFirstForbidden RegisterPlayer
  deriving (Eq, Show)
instance HTraversable RegFirstForbidden where
  htraverse _ (RegFirstForbidden rp) =
    pure (RegFirstForbidden rp)
```

## `cRegisterFirst`

```haskell
cRegisterFirst
  :: ( MonadGen n
     , MonadIO m
     , MonadTest m
     )
  => ClientEnv
  -> Command n m SimpleState
cRegisterFirst env =
  Command cRegisterFirstGen
          (cRegisterFirstExe env)
          cRegisterFirstCallbacks
```

##

```haskell
cRegisterFirstGen
  :: MonadGen n
  => SimpleState Symbolic
  -> Maybe (n (RegFirst Symbolic))





```

##

```haskell
cRegisterFirstGen
  :: MonadGen n
  => SimpleState Symbolic
  -> Maybe (n (RegFirst Symbolic))
cRegisterFirstGen (SimpleState registeredFirst) =
  if registeredFirst
  then Nothing
  else Just (RegFirst <$> genRegPlayerRandomAdmin)
```

##

```haskell
cRegisterFirstExe
  :: ( MonadIO m
     , MonadTest m
     )
  => ClientEnv
  -> RegFirst Concrete
  -> m ResponsePlayer



```

##

```haskell
cRegisterFirstExe
  :: ( MonadIO m
     , MonadTest m
     )
  => ClientEnv
  -> RegFirst Concrete
  -> m ResponsePlayer
cRegisterFirstExe env (RegFirst rp) =
  evalEither =<< successClient env (registerFirst rp)
```

##

```haskell
successClient
  :: MonadIO m
  => ClientEnv -> ClientM a -> m (Either ServantError a)

evalEither
  :: (MonadTest m, Show x, HasCallStack)
  => Either x a -> m a

  evalEither =<< successClient env (registerFirst rp)
```

##

```haskell
cRegisterFirstCallbacks
  :: [Callback RegFirst ResponsePlayer SimpleState]












```

##

```haskell
cRegisterFirstCallbacks
  :: [Callback RegFirst ResponsePlayer SimpleState]
cRegisterFirstCallbacks =
  [ Require $ \(SimpleState registeredFirst) _i ->
      not registeredFirst







  ]
```

##

```haskell
cRegisterFirstCallbacks
  :: [Callback RegFirst ResponsePlayer SimpleState]
cRegisterFirstCallbacks =
  [ Require $ \(SimpleState registeredFirst) _i ->
      not registeredFirst
  , Update $ \_sOld _i _o -> SimpleState True






  ]
```

##

```haskell
cRegisterFirstCallbacks
  :: [Callback RegFirst ResponsePlayer SimpleState]
cRegisterFirstCallbacks =
  [ Require $ \(SimpleState registeredFirst) _i ->
      not registeredFirst
  , Update $ \_sOld _i _o -> SimpleState True
  , Ensure $ \_sOld _sNew _input out ->
      case out of
        (ResponsePlayer (LS.PlayerId (Auto mId))
                        (Token token)) -> do
          assert $ not (BS.null t)
          assert $ maybe False (>= 0) mId
  ]
```

## `cRegisterFirstForbidden`

##

```haskell
cRegisterFirstForbiddenGen
  :: MonadGen n
  => SimpleState Symbolic
  -> Maybe (n (RegFirstForbidden Symbolic))





```

##

```haskell
cRegisterFirstForbiddenGen
  :: MonadGen n
  => SimpleState Symbolic
  -> Maybe (n (RegFirstForbidden Symbolic))
cRegisterFirstForbiddenGen (SimpleState registeredFirst) =
  if registeredFirst
  then Just (RegFirstForbidden <$> genRegPlayerRandomAdmin)
  else Nothing
```

##

```haskell
cRegisterFirstForbiddenExe
  :: ( MonadIO m
     , MonadTest m
     )
  => ClientEnv
  -> RegFirstForbidden Concrete
  -> m ServantError



```

##

```haskell
cRegisterFirstForbiddenExe
  :: ( MonadIO m
     , MonadTest m
     )
  => ClientEnv
  -> RegFirstForbidden Concrete
  -> m ServantError
cRegisterFirstForbiddenExe env (RegFirstForbidden rp) =
  evalEither =<< failureClient env (registerFirst rp)
```

##

```haskell
cRegisterFirstForbiddenCallbacks
  :: [Callback RegFirstForbidden ServantError SimpleState]










```
##

```haskell
cRegisterFirstForbiddenCallbacks
  :: [Callback RegFirstForbidden ServantError SimpleState]
cRegisterFirstForbiddenCallbacks = [
    Require $ \(SimpleState registeredFirst) _input ->
      registeredFirst





  ]
```


##

```haskell
cRegisterFirstForbiddenCallbacks
  :: [Callback RegFirstForbidden ServantError SimpleState]
cRegisterFirstForbiddenCallbacks = [
    Require $ \(SimpleState registeredFirst) _input ->
      registeredFirst
  , Ensure $ \_sOld _sNew _input se ->
      case se of
        FailureResponse{..} ->
          responseStatus === forbidden403
        _ -> failure
  ]
```

## `propRegisterFirst`

```haskell
propRegisterFirst :: ClientEnv -> IO () -> TestTree
propRegisterFirst env reset =












```

##

```haskell
propRegisterFirst :: ClientEnv -> IO () -> TestTree
propRegisterFirst env reset =
  testProperty "register-first" . property $ do
    let
      initialState = SimpleState False









```

##

```haskell
propRegisterFirst :: ClientEnv -> IO () -> TestTree
propRegisterFirst env reset =
  testProperty "register-first" . property $ do
    let
      initialState = SimpleState False
      cs = [ cRegisterFirst env
           , cRegisterFirstForbidden env]







```

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





```

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

    liftIO reset
    executeSequential initialState actions
```

## Test setup

- Start a temporary database instance
- Fork a thread to run our server (starting with DB migration)
- Run properties with `ClientEnv`

## { data-background-image="images/hedgehog-running.gif"
      data-background-transition="none"
    }

## {data-background-image="images/register-first-success.png"
     data-background-size="80%"
    }

## { data-background-image="images/hedgehog-failing.gif"
      data-background-transition="none"
    }

##

```haskell
cRegisterFirstGen (SimpleState registeredFirst) =
  if registeredFirst
  then Nothing
  else Just (RegFirst <$> genRegPlayerRandomAdmin)
```

##

```haskell
cRegisterFirstGen (SimpleState registeredFirst) =
  Just (RegFirst <$> genRegPlayerRandomAdmin)



```

##

```haskell
cRegisterFirstCallbacks =
  [ Require $ \(SimpleState registeredFirst) _i ->
      not registeredFirst
  , Update $ \_sOld _i _o -> SimpleState True
  , Ensure $ \_sOld _sNew _input out ->
      case out of
        (ResponsePlayer (LS.PlayerId (Auto mId))
                        (Token token)) -> do
          assert $ not (BS.null t)
          assert $ maybe False (>= 0) mId
  ]
```

##

```haskell
cRegisterFirstCallbacks =
  [ 
    
    Update $ \_sOld _i _o -> SimpleState True
  , Ensure $ \_sOld _sNew _input out ->
      case out of
        (ResponsePlayer (LS.PlayerId (Auto mId))
                        (Token token)) -> do
          assert $ not (BS.null t)
          assert $ maybe False (>= 0) mId
  ]
```

## {data-background-image="images/reg-first-error.png"
     data-background-size="80%"
    }

## {data-background-image="images/reg-first-error-cmds.png"
     data-background-size="80%"
    }

