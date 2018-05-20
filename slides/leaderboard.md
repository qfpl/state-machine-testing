# Leaderboard

## 

Keeps track of game scores and player ratings.

## API

<div class="notes">
These correspond roughly to our actions. We'll see later we can have multiple
actions/transitions per endpoint.

Have tried to strike a balance between "real world" and "will coherently fit in a 25 minute talk"
</div>

::: no-bullets

- `/player/register-first`
- `/player/register`
- `/player/me`
- `/player/player-count`

:::

##

```haskell
type PlayerAPI auths =
  "player" :> (
       Auth auths PlayerSession :> "register"
       :> ReqBody '[JSON] RegisterPlayer
       :> Post '[JSON] ResponsePlayer
  :<|> "register-first"
       :> ReqBody '[JSON] RegisterPlayer
       :> Post '[JSON] ResponsePlayer
  :<|> Auth auths PlayerSession :> "me"
       :> Get '[JSON] Player
  :<|> "count" :> Get '[JSON] PlayerCount
  )
```

## Properties

- Can only `register-first` once
- Player count matches number of successful registrations
- Retrieving a player matches what was `POST`ed
- Player identifiers (emails) remain unique

