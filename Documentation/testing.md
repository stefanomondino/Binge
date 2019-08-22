# Unit Testing

Unit tests are managed with [Quick](https://github.com/Quick/Quick) framework in a **BDD** style.

**Behavior Driven Development** is a special TDD approach that:
- requires **tests** to be written **before** implementation
- defines empty **specs** in a human-readable language

When writing Tests, the proper procedure is:
1. write the empty specs and test -> the test succeeds but nothing happens
2. write some *expectations* inside your empty specs that should define what outcome you're expecting from a function/object/module. That module should be unimplemented, and the test should now **fail**
3. implement the logic in the object until the expectations **succeed**

This approach (more time consuming in the early stages) ensures that any further line of code written in the custom object will always be "under control": if anything against the original specification is written, the previous test fails explaining what is wrong.

Unless project specification are changed, there should never exist a case where the test needs to be edited in order to let the program succeed. It's more likely a developer mistake in the application codebase that needs to be handled and fixed.

## Structure

Each target has it's own test suite.
It's a matter of **what** should be tested in each scenario.

The important thing to keep in mind is that tests should never depend on external features: testing how the app works with the remote APIs is completely out of scope and useless.
Tests should be *deterministic*, meaning that the same test execution should't succeed or fail if remote server is turned off or no network connection is available.  

For these reasons, we define **Mocks** object, simulations of external data with a pre-determined outcome

Example: we store a JSON file with a sample API response and pretend that each call to that API endpoint always returns that data. Since we know its contents, we're able to define how the app should behave in that particular scenario. It's up to the developer to understand, define and test every meaningful scenario by creating enough mocks.

A good indicator of how many lines of code are being tested is the **code coverage**: XCode automatically checks and counts every time a single line of code is executed. If the count is 0, that part of code is definetly not being tested. 


### Model
In the Model environment, the main scope is to test the outcome of each **UseCase**

For this reason, we need to:
- **Mock** JSONS and Datasources, so that we can replace a REST datasource with an "internal" one, and have it to return a specific JSON
- **Inject** custom repositories in use cases, by creating a new Repository that conforms to the same protocol the original one is conforming to, and by replacing its datasources with mocked ones
- **Test** a use case against provided mocks with injected repositories.

### ViewModel

In the ViewModel environment, the main scope is to test the outcome of each **ViewModel** (usually Item or List)

For this reason, we need to:
- **Mock** Model's UseCases and Entities by simulating a specific, well-known outcome from every Observable exposed by a single UseCase
- **Inject** fake entities by creating a single Entity with mocked contents (usually by creating a `mock()` static constructor on every entity with some dummy data inside)
- **Test** every single ViewModel: for an `ItemViewModelType` we should test exposed properties, for `ListViewModelType` we should test proper grouping (`DataGroup`) and generated ItemViewModels

### App

Since MVVM should already have taken care of business logic and data formatting, and standard components are already guaranteed to be tested, it's quite safe to leave out the App targets from testing.

However, Skeleton provides some tests about app's configuration, by testing:
- Each `Scene` should be created without app crash (test each xib)
- Each `View` should be created without app crash (test each xib)
- Each `Strings` should be available
- Each `Images` should be available