# Example 2: Player count

## Property

Successfully registering a player increments the player count.

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

##

```haskell
instance HTraversable PlayerWithRsp where
  htraverse f PlayerWithRsp{..} =
    let mkP _pwrRsp = PlayerWithRsp{..}
    in case _pwrRsp of
        (Var vr) -> mkP <$> (Var <$> f vr)
```

## Commands

## `cGetPlayerCount`

##

```haskell
data GetPlayerCount (v :: * -> *) =
    GetPlayerCount
  deriving (Eq, Show)

instance HTraversable GetPlayerCount where
  htraverse _ _ = pure GetPlayerCount
```

## 

```haskell
Ensure $ \(LeaderboardState ps as _ms) _sNew _i c -> do
  annotateShow ps
  annotateShow as
  length ps === fromIntegral c
  assert $ length ps >= length as
```

## `cRegFirst`

##

```haskell
[ Require $ \(LeaderboardState ps _as) _input -> null ps
, Update $
    \(LeaderboardState _ps _as)
     (RegFirst lbr@LeaderboardRegistration{..}) rsp ->
       let
         player = mkPlayerWithRsp lbr rsp
         players = M.singleton _lbrEmail newPlayer
         admins = S.singleton _lbrEmail
       in
         LeaderboardState players admins
]
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
data Register (v :: * -> *) =
  Register RegisterPlayer (PlayerWithRsp v)
  deriving (Eq, Show)

instance HTraversable Register where
  htraverse f (Register rp PlayerWithRsp{..}) =
    let
      mkFP (Var rsp) =
        fmap (\_pwrRsp -> PlayerWithRsp{..}) $ Var <$> f rsp
    in
      Register rp <$> mkFP _pwrRsp
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
Require $ \(LeaderboardState _ as) (Register _ p) ->
  S.member (_pwrEmail p) as
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

