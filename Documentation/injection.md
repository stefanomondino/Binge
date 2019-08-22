# Dependency injection and Inversion of control

In Skeleton, we define the concept of **Dependency Injection** as a way to configure important parameters of an object or function outside of its main scope.

This feature can techically be achieved in may ways:
- By explicitly exposing parameters in method definition 
- By statically overriding or setting global variables
- With **inverion of control** through **dependency containers**

First of all, **why** is dependency injection necessary?

DI is crucial in environments where *configuration* needs to be separated from *logic* 

In our main case, we should handle the same *logic* in the real scenario (the app) but also be able to mock (test) the environment without altering the normal app flow by internally "simulating" a well-known case and handle how the software should react.

In the `Model` layer we normally have repositiories and datasources connected to REST APIs. Dependency injection allow us to change (for instance) a repository with a mocked one, conforming to a common `protocol` and without worrying about further changes in the app.

## Inversion of control

**Inversion of control** is a specific way to implement dependency injection by using some shared *container* that stores pieces of logic that can be retrieved later on in another context.

Those pieces of logic (usually *closures*) are defined during a **bootstrap** phase of the application, that must happen before any scene is loaded. They are **registered** inside a container by using a special, unique and meaningful *identifier* and stored for the whole lifecycle of the app. This container is referenced by those objects that have to *consume* the registered logic at some time. At that point, consumers try to **resolve** the original object/closure with the same *identifier* and use the result as if it was local.

This is used to implement Boomerang concepts across App and ViewModel frameworks:

- `ViewModel` must define `SceneIdentifier`s to use them inside `SceneViewModelType` objects
- `SceneIdentifier` protocol requires to implement `scene()` method that requires knowledge of the `View`, not available in `ViewModel`
- Different apps may share same `ViewModel` layer but may want to implement those `Scene`s in different ways (example: iOS and tvOS targets)

`scene()` method is then implemented through `Inversion of Control`:

- in `App`'s `bootstrap` phase, the `scene()` internal [implementation](../Sources/App/Configuration/Scenes.swift) is registered inside a static container inside the `ViewModel` layer
- the actual `scene()` [implementation](../Sources/ViewModel/Identifiers/Dependencies/Scenes+Dependency.swift) (in `ViewModel`) tries to `resolve()` the container for current identifier 

Same thing happens for Routes, Views, Images, Strings and whenever required.
