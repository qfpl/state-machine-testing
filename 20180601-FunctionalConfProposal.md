# Hedgehog State Machine Testing

**Category**: Technique

**Level**: Intermediate

**Session Type**: Talk

## Abstract

Automated testing is key to ensuring the ongoing health and well-being of any software project,giving
developers and users confidence that their software works as intended. Property based testing is a
significant step forward compared to traditional unit tests, exercising code with randomly generated
inputs to ensure that key properties hold. However, both of these techniques tend to be used at the
level of individual functions. Many important properties of an application only appear at a higher
level, and depend on the state of the application under test. The Haskell library hedgehog, a
relative newcomer to the property based testing world, includes facilities for property-based state
machine testing, giving developers a foundation on which to build these more complicated tests.

In this talk, Andrew will give you an introduction to state machine property testing using
hedgehog. He'll start with a quick refresher on property based testing, followed by a brief
introduction to state machines and the sorts of applications they can be used to model. From there,
he'll take you on a guided tour of hedgehog's state machine testing facilities. Finally, Andrew will
present a series of examples to show off what you can do and hopefully give you enough ideas to start
applying this tool to your own projects. The application being tested will be a servant web
application, and examples will include testing fundamentals such as content creation and deletion,
uniqueness constraints, and authentication. Finally, Andrew will demonstrate how parallel
state machine tests can be used to find issues found in systems that allow concurrent access to state
(e.g. most web applications).

An intermediate knowledge of Haskell and familiarity with property based testing will be
beneficial,but not essential. The slides and demo application will be available after the talk for
people to study in detail.

## Target audience

Anyone interested in testing stateful software (e.g. web applications).

## Session prerequisite

A basic understanding of property based testing, ideally using the hedgehog library, is expected; as
is a basic understanding of web programming. Knowledge of Haskell is beneficial, but not necessary.

## Outline/structure

The basic outline of the talk is as follows

- Identify the problem that motivates state machine testing
- Quick refresher of/intro to hedgehog and property based testing. As this is expected knowledge, this
  will be very brief.
- Quick intro/refresher on state machines.
- An introduction to state machine property testing in hedgehog.
    + Overview of hedgehog's approach.
    + Explanation of key data types.
    + Explanation of hedgehog's variable handling.
    + Parallel state machine testing
- Examples:
    + A simple test where the state is a boolean flag.
    + Ensure the count of users matches the number of successful registrations.
    + Round trip property -- retrieved data matches what was submitted.
    + Uniqueness -- cannot add multiple users with the same identifier.
    + Transaction conflict resulting from concurrent requests.

The number and complexity of examples will depend on the time available. For example, parallel examples
may not be covered.

## Learning Outcomes

After seeing this talk attendees will:

 - Know how to model stateful applications as state machines.
 - Understand how the haskell library hedgehog can be used for state machine testing.
 - Be able to write property based tests for stateful applications using hedgehog.

## Labels

haskell, property-based testing, state machine testing, hedgehog, servant
