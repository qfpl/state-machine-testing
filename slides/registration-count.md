# Example 2: Player count

## Property

Successfully registering a player increments the player count.

## { data-background-image="images/user-count.svg"
      data-background-color="white"
      data-background-size="80%"
      data-background-transition="none"
    }

## State

```haskell
data LeaderboardState (v :: * -> *) =
  LeaderboardState
  { _players :: M.Map Text (PlayerWithRsp v)
  , _admins  :: S.Set Text
  }
deriving instance Show1 v => Show (LeaderboardState v)
deriving instance Eq1 v => Eq (LeaderboardState v)
```

##

```haskell
data PlayerWithRsp v =
  PlayerWithRsp
  { _pwrRsp      :: Var ResponsePlayer v




  }
  deriving (Eq, Show)
```

##

```haskell
data PlayerWithRsp v =
  PlayerWithRsp
  { _pwrRsp      :: Var ResponsePlayer v
  , _pwrEmail    :: Text
  , _pwrUsername :: Text
  , _pwrPassword :: Text
  , _pwrIsAdmin  :: Maybe Bool
  }
  deriving (Eq, Show)
```

## Commands

## `cRegFirst`

##

```haskell
Update $
  \_ (RegFirst lbr@LeaderboardRegistration{..}) rsp ->







```
##

```haskell
Update $
  \_ (RegFirst lbr@LeaderboardRegistration{..}) rsp ->
     let
       player = mkPlayerWithRsp lbr rsp





```
##

```haskell
Update $
  \_ (RegFirst lbr@LeaderboardRegistration{..}) rsp ->
     let
       player = mkPlayerWithRsp lbr rsp
       players = M.singleton _lbrEmail newPlayer




```
##

```haskell
Update $
  \_ (RegFirst lbr@LeaderboardRegistration{..}) rsp ->
     let
       player = mkPlayerWithRsp lbr rsp
       players = M.singleton _lbrEmail newPlayer
       admins = S.singleton _lbrEmail



```
##

```haskell
Update $
  \_ (RegFirst lbr@LeaderboardRegistration{..}) rsp ->
     let
       player = mkPlayerWithRsp lbr rsp
       players = M.singleton _lbrEmail newPlayer
       admins = S.singleton _lbrEmail
     in
       LeaderboardState players admins
```

## `cGetPlayerCount`

##

```haskell
data GetPlayerCount (v :: * -> *) =
    GetPlayerCount
  deriving (Eq, Show)
```

## 

```haskell
Ensure $ \(LeaderboardState ps as) _sNew _i c -> do
  length ps === fromIntegral c
  assert $ length ps >= length as
```

## `cRegister`

##

```haskell
data Register (v :: * -> *) =
  Register RegisterPlayer (PlayerWithRsp v)
  deriving (Eq, Show)
```

##

```haskell
cRegisterGen rs@(LeaderboardState ps as) =
  if null as
  then Nothing









```

##

```haskell
cRegisterGen rs@(LeaderboardState ps as) =
  if null as
  then Nothing
  else
    let
      maybeGenAdmin :: Maybe (n (PlayerWithRsp v))
      maybeGenAdmin =
        pure $ (M.!) ps <$> (Gen.element . S.toList $ as)




```

##

```haskell
cRegisterGen rs@(LeaderboardState ps as) =
  if null as
  then Nothing
  else
    let
      maybeGenAdmin :: Maybe (n (PlayerWithRsp v))
      maybeGenAdmin =
        pure $ (M.!) ps <$> (Gen.element . S.toList $ as)
    in
      (Register <$> genRegPlayerRandomAdmin ps <*>)
        <$> maybeGenAdmin
```

##

```haskell
[ Require $ \(LeaderboardState _ as) (Register _ p) ->
    S.member (_pwrEmail p) as
, Require $ \(LeaderboardState ps _) (Register rp _) ->
    M.notMember (_lbrEmail rp) ps
]
```

##

```haskell
Update $
  \(LeaderboardState ps as)
   (Register rp@LeaderboardRegistration{..} _)
   rsp ->










```

##

```haskell
Update $
  \(LeaderboardState ps as)
   (Register rp@LeaderboardRegistration{..} _)
   rsp ->
     let
       newPlayers =
         M.insert _lbrEmail (mkPlayerWithRsp rp rsp) ps







```

##

```haskell
Update $
  \(LeaderboardState ps as)
   (Register rp@LeaderboardRegistration{..} _)
   rsp ->
     let
       newPlayers =
         M.insert _lbrEmail (mkPlayerWithRsp rp rsp) ps
       newAdmins =
         case _lbrIsAdmin of
           Just True -> S.insert _lbrEmail as
           _         -> as



```

##

```haskell
Update $
  \(LeaderboardState ps as)
   (Register rp@LeaderboardRegistration{..} _)
   rsp ->
     let
       newPlayers =
         M.insert _lbrEmail (mkPlayerWithRsp rp rsp) ps
       newAdmins =
         case _lbrIsAdmin of
           Just True -> S.insert _lbrEmail as
           _         -> as
     in
       LeaderboardState newPlayers newAdmins
```

##

```haskell
propRegisterCount env reset =
  testProperty "register-counts" . property $ do










```

##

```haskell
propRegisterCount env reset =
  testProperty "register-counts" . property $ do
  let
    initialState = LeaderboardState M.empty S.empty








```

##

```haskell
propRegisterCount env reset =
  testProperty "register-counts" . property $ do
  let
    initialState = LeaderboardState M.empty S.empty
    commands = [
        cRegisterFirst env
      , cRegisterFirstForbidden env
      , cRegister env
      , cGetPlayerCount env
      ]
  -- rest is the same as register-first
```

## { data-background-image="images/hedgehog-running.gif"
      data-background-transition="none"
    }
    
## { data-background-image="images/register-counts-success.png"
      data-background-size="80%"
    }

