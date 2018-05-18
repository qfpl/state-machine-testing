# What and why?

## Testing in the large

<div class="notes">
- Testing in the small with unit and property tests is a powerful tool.
- However, there are many critical properties of a system that aren't so
  easily or obviously tested with these tools.
- These properties often involve how state is handled as new inputs arrive.
</div>

## The Plan

- Property based testing
- State machines
- Property based testing _for_ state machines
- Examples

## The not-plan

- Servant
- Details of property based testing or hedgehog
- Details of test infrastructure

<div class="notes">
- Servant is incidental, but has a benefit to testing.
- Assume you're familiar with the basic concept of property testing and hedgehog.
- Watch Jacob's outstanding talk from last year.
- Test infrastructure refers to all the code that sets up the database, runs the app, etc.
- All code is up on github, so you feel free to take a look and find me on the internet if you have questions.
</div>
