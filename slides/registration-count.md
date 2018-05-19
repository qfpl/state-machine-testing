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
data PlayerWithRsp v =
  PlayerWithRsp
  { _pwrRsp      :: Var ResponsePlayer v
  , _pwrEmail    :: Text
  , _pwrUsername :: Text
  , _pwrPassword :: Text
  , _pwrIsAdmin  :: Maybe Bool
  }
  deriving (Eq, Show)

instance HTraversable PlayerWithRsp where
  htraverse f PlayerWithRsp{..} =
    case _pwrRsp of
      (Var vr) -> (\_pwrRsp -> PlayerWithRsp{..}) <$> (Var <$> f vr)
```

