# Example 4: Parallelism

##

- Run a sequential prefix to generate a random initial state.
- Run two sequences of commands in parallel.
- Look for a valid linearization of the results.

## { data-background-image="images/linearization.png"
      data-background-color="white"
      data-background-size="80%"
      data-background-transition="none"
    }

##

```haskell
propRegisterCount env reset =
  testProperty "register-counts" .
  withRetries 10 . property $ do
  let
    initialState = LeaderboardState M.empty S.empty
    commands = [ {- commands here -} ]
  actions <- forAll $
    Gen.parallel (Range.linear 10 100)
      (Range.linear 1 10) initialState commands
  test $ do
    evalIO reset
    executeParallel initialState actions
```

##

```haskell
propRegisterCount env reset =
  
  withRetries 10 . property $ do










```

##

```haskell
propRegisterCount env reset =





  actions <- forAll $
    Gen.parallel (Range.linear 10 100)
      (Range.linear 1 10) initialState commands




```

##

```haskell
propRegisterCount env reset =




 
 

  -- `test` needed because of `MonadBaseControl` constraint
  test $ do
    evalIO reset
    executeParallel initialState actions
```

## { data-background-image="images/hedgehog-failing.gif"
      data-background-transition="none"
    }
    
## { data-background-image="images/para-failure.png"
      data-background-size="40%"
      data-background-transition="none"
    }
    
## { data-background-image="images/para-fail-error.png"
      data-background-size="70%"
      data-background-transition="none"
    }
    
##

```haskell
cGetPlayerCountGen
  :: MonadGen n
  => LeaderboardState Symbolic
  -> Maybe (n (GetPlayerCount Symbolic))
cGetPlayerCountGen (LeaderboardState ps _) =
  Just (pure GetPlayerCount)



```

##

```haskell
cGetPlayerCountGen
  :: MonadGen n
  => LeaderboardState Symbolic
  -> Maybe (n (GetPlayerCount Symbolic))
cGetPlayerCountGen (LeaderboardState ps _) =
  if not (null ps)
  then Just (pure GetPlayerCount)
  else Nothing
```

## { data-background-image="images/para-fail2.png"
      data-background-size="30%"
      data-background-transition="none"
    }
    


