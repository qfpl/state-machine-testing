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

## `cRegisterFirst`

```haskell
cRegisterFirst
  :: ( MonadGen n
     , MonadIO m
     )
  => ClientEnv
  -> Command n m SimpleState
```

##

**`cRegisterFirst` --- generator**

```haskell
cRegisterFirst env =
  let
    gen (SimpleState registeredFirst) =
      if registeredFirst
      then Nothing
      else Just (RegFirst <$> genRegPlayerRandomAdmin)
 
 
 
 
```

##

**`cRegisterFirst` --- execute**

```haskell
cRegisterFirst env =
  let
    gen (SimpleState registeredFirst) =
      if registeredFirst
      then Nothing
      else Just (RegFirst <$> genRegPlayerRandomAdmin)
    execute (RegFirst rp) =
      let mkError =
            ("Error registering first user: " <>) . show
      in successClient mkError env . registerFirst $ rp
```

##

**`cRegisterFirst` --- execute**

```haskell
cRegisterFirst env =








      in successClient mkError env . registerFirst $ rp
```

##

```haskell
successClient
  :: MonadIO m
  => (ServantError -> String)
  -> ClientEnv
  -> ClientM a
  -> m a
successClient f ce a = do
  r <- liftIO $ runClientM a ce
  either (fail . f) pure r
```

##

**`cRegisterFirst` --- `Require`**

```haskell
cRegisterFirst env =
  -- let bindings elided
  in
    Command gen execute [
      Require $ \(SimpleState registeredFirst) _input ->
        not registeredFirst
 

    ]
```

##

**`cRegisterFirst` --- `Update`**

```haskell
cRegisterFirst env =
  -- let bindings elided
  in
    Command gen execute [
      Require $ \(SimpleState registeredFirst) _input ->
        not registeredFirst
    , Update $ \_oldState _regFirst _output ->
        SimpleState True
    ]
```

##

**`cRegisterFirst` --- `Ensure`**

```haskell
cRegisterFirst env =
  -- let bindings elided
  in
    Command gen execute [
    -- Require and Update elided
    , Ensure $ \_sOld _sNew _input out ->
        case out of
          (ResponsePlayer (LS.PlayerId (Auto mId)) _token) ->
            assert $ maybe False (>= 0) mId
    , Ensure $ \_sOld _sNew _input out ->
        case out of
          (ResponsePlayer _pId (Token t)) ->
            assert $ not (BS.null t)
    ]
```

## `cRegisterFirstForbidden`

```haskell
cRegisterFirstForbidden
  :: ( MonadGen n
     , MonadIO m
     )
  => ClientEnv
  -> Command n m SimpleState
```

##

**`cRegisterFirstForbidden` --- `gen`**

```haskell
cRegisterFirstForbidden env =
  let
    gen (SimpleState registeredFirst) =
      if registeredFirst
      then Just $ RegFirstForbidden <$>
        genRegPlayerRandomAdmin
      else Nothing





```

##

**`cRegisterFirstForbidden` --- `execute`**

```haskell
cRegisterFirstForbidden env =
  let
    gen (SimpleState registeredFirst) =
      if registeredFirst
      then Just $ RegFirstForbidden <$>
        genRegPlayerRandomAdmin
      else Nothing
    execute (RegFirstForbidden rp) =
      failureClient (const "Should fail with 403")
                    env
                    (registerFirst rp)
```

##

**`cRegisterFirstForbidden` --- `Require`**

```haskell
cRegisterFirstForbidden env =
  -- lets elided
  in
    Command gen execute [
      Require $ \(SimpleState registeredFirst) _input ->
        registeredFirst
      -- State shouldn't change, so no `Update`





    ]
```

##

**`cRegisterFirstForbidden` --- `Ensure`**

```haskell
cRegisterFirstForbidden env =
  -- lets elided
  in
    Command gen execute [
      Require $ \(SimpleState registeredFirst) _input ->
        registeredFirst
      -- State shouldn't change, so no `Update`
    , Ensure $ \_sOld _sNew _input se ->
        case se of
          FailureResponse{..} ->
            responseStatus === forbidden403
          _ -> failure
    ]
```

## Putting it all together

- Start a temporary database instance
- Fork a thread to run our server (starting with DB migration)
- Use `servant-client` to make requests to the server
- Reset database state before each execution

<div class="notes">
Can look at how the code does this, but no more details in this talk.

"before each execution" means before first run _and_ before any shrinks get run
</div>

##

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

    test $ do
      liftIO reset
      executeSequential initialState actions
```

<div class="notes">
`property` defaults to 100 test passes required
</div>

## Output - success

```
leaderboard
  registration-simple
    register-first: OK (6.96s)
      OK

All 1 tests passed (6.97s)
```

<div class="notes">
Given 100 test runs with up to 100 requests in each, theoretically generating 10,000
requests, running them, updating state, and checking post conditions.
</div>

## Failures

##

```haskell
let
  gen (SimpleState registeredFirst) =
    Just (RegFirst <$> genRegPlayerRandomAdmin)
    -- if registeredFirst
    -- then Nothing
    -- else Just (RegFirst <$> genRegPlayerRandomAdmin)









```

##

```haskell
let
  gen (SimpleState registeredFirst) =
    Just (RegFirst <$> genRegPlayerRandomAdmin)
    -- if registeredFirst
    -- then Nothing
    -- else Just (RegFirst <$> genRegPlayerRandomAdmin)
  execute (RegFirst rp) =
     evalEither =<< successClient env (registerFirst rp)







```

##

```haskell
let
  gen (SimpleState registeredFirst) =
    Just (RegFirst <$> genRegPlayerRandomAdmin)
    -- if registeredFirst
    -- then Nothing
    -- else Just (RegFirst <$> genRegPlayerRandomAdmin)
  execute (RegFirst rp) =
     evalEither =<< successClient env (registerFirst rp)
in
  Command gen execute [
    --Require $ \(SimpleState registeredFirst) _input ->
    --  not registeredFirst
    -- Update and Ensures the same
  ]
```

##

![register first error](images/reg-first-error.png)\

##

![register first error commands](images/reg-first-error-cmds.png)\

