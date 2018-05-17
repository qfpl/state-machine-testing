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

### `cRegisterFirst` --- generator

```haskell
cRegisterFirst env =
  let
    gen (SimpleState registeredFirst) =
      if registeredFirst
      then Nothing
      else Just (RegFirst <$> genRegPlayerRandomAdmin)
 
 
 
 
```

##

### `cRegisterFirst` --- execute

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

### `cRegisterFirst` --- `Require`

```haskell
cRegisterFirst env =
  -- let bindings elided
  in
    Command gen execute [
      Require $ \(SimpleState registeredFirst) _input ->
        not registeredFirst
    , Update $ \_oldState _regFirst _output ->
        SimpleState True
    , Ensure $
        \(SimpleState rOld)
         (SimpleState rNew)
         _input
         (ResponsePlayer
           (LS.PlayerId (Auto mid))
           (Token t)) -> do
        rOld === False
        rNew === True
        assert $ maybe False (>= 0) mid
        assert $ not (BS.null t)
    ]
```

### `cRegisterFirst` --- `Update`

```haskell
cRegisterFirst env =
  -- let bindings elided
  in
    Command gen execute [
      Require $ \(SimpleState registeredFirst) _input ->
        not registeredFirst
    , Update $ \_oldState _regFirst _output ->
        SimpleState True
    , Ensure $
        \(SimpleState rOld)
         (SimpleState rNew)
         _input
         (ResponsePlayer
           (LS.PlayerId (Auto mid))
           (Token t)) -> do
        rOld === False
        rNew === True
        assert $ maybe False (>= 0) mid
        assert $ not (BS.null t)
    ]
```

### `cRegisterFirst` --- `Ensure`

```haskell
cRegisterFirst env =
  -- let bindings elided
  in
    Command gen execute [
      Require $ \(SimpleState registeredFirst) _input ->
        not registeredFirst
    , Update $ \_oldState _regFirst _output ->
        SimpleState True
    , Ensure $
        \(SimpleState rOld)
         (SimpleState rNew)
         _input
         (ResponsePlayer
           (LS.PlayerId (Auto mid))
           (Token t)) -> do
        rOld === False
        rNew === True
        assert $ maybe False (>= 0) mid
        assert $ not (BS.null t)
    ]
```

## Putting it all together

- Start a temporary database instance
- Fork a thread to run our server
- Use `servant-client` to make requests to the server
- Reset database state between runs

<div class="notes">
Can look at how the code does this, but no more details in this talk.
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
      cs = [ cRegisterFirst env
           , cRegisterFirstForbidden env]
 
 

 
 
 
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
