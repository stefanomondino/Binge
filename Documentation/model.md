# Model

The `Model` crossplatform framework is responsible of raw data retrieval and transformation, in order to provide listening ViewModels with ready-to-be-consumed data.

This is usually done by creating plain swift objects that are called `Entities`, usually passive `struct`s with typed values.

In order to have a solid, testable infrastructure that can seamlessly adapt to almost any scenario, we'll use the **Repository Pattern** that is composed of hierarchical layers:

- **Entity**
- **DataSource**
- **Repository**
- **UseCase**

# Entity

An entity is a passive object that encapsulates raw data.

The most common scenario we usually deal with is the JSON representation of data into a Swift object. For this reason, we're going to use the `Codable` protocol on each Entity that will automatically expose property mapping without the need of explicitly define it.

A very simple example of Entity is 

```swift
public struct Product: Codable {
    public let id: Int
    public let name: String
    public let barcode: String
}
```

that match this JSON

```javascript
{
    "id": 1,
    "name": "iPhone XS",
    "barcode": "xxxx-xxxx-xxxx"
}
```

Custom mappings can be handled through `CodingKeys` or manually serialization.

# DataSource

A DataSource is the object responsible to retrieve raw data from a specific source type and transforming that data into a single Entity or an array of Entities.

An example of DataSource is a REST client that downloads JSON and transforms it into Entities. In our case, the REST client is a `MoyaProvider` (from the [Moya](https://github.com/Moya/Moya) library).

Another examples of DataSource can be a cache provider, a CoreData database, a Firebase's FireStore/Realtime database. 

Each DataSource has to implement
```swift
 func object<T: ObjectType, P: DataSourceParameters>(for parameters: P) -> Observable<T>
 ```
 converting an object that defines some parameters (a REST endpoint, a DB query, etc...) into a mapped, `Codable` response (either single object or array).

 Skeleton provides out of the box DataSource implementations for `MoyaProvider` and `Cache`.

# Repository

A repository incapsulates one or more datasource and expose simpler methods that only returns observables of Entities matching specific parameters.

A common scenario is a full list of products that can be cached locally and downloaded from a REST Api if network connection is available.

A repository should expose a `func products() -> Observable<[Product]>` method that would implement something like (untested):

```swift
func products() -> Observable<[Product]> {
    let listParameters: ProductParameters = ...
    return cacheDataSource
            .object(for: listParameters)
            .catchErrorJustReturn([])
            .flatMapLatest ({ cached in
                return apiDataSource.object(for: listParameters).startWith(cached)
            })
}
```
`listParameters` is some pre-defined structure containing endpoint information. 
For a `MoyaProvider` DataSource (here `apiDataSource`), that is an object (usuallu `enum`) conforming to `TargetType`.

Mapping to `[Product]` is handled through Swift's type inference.

A single repository can contain many of these functions, and it should group according to shared functionalities.

If remote APIs provide endpoints for Products and Users, there should be a `Repository` for Products and one for Users, each one handling listing, filtering, creating and updating objects.

Projects with a single repository are **highly discouraged**, as they tend to become messy when the project scale and evolves.

Repositories bring order and high testability: each repository should declare a matching `protocol` exposing each non-private method and variable. 

In the `Repositories.swift` file there's a static reference to each Repository that can be replaced at runtime with a Mocked repository if needed.

# UseCase

A `UseCase` is the public link between `ViewModel` and `Model`.

A UseCase should publicly exposes properties and entities by combining observables from repositories. Use cases are usually coupled with the needs of view model and, more in general, app's screens, and lock a subset of functionalities that are available in current app context.

Let's imagine an app that handles product listing, creation and update.

The `ProductsUseCase` would probably expose a `products()` function that use the `ProductsRepository`'s `products()` method to retrieve the list but doesn't declare a `createProduct()`, explicitly forbidding its misuse.

When using XCode autocomplete features, it becomes immediately clear what can be used in a `ViewModel`. 

Each repository should have matching `protocol` for public functions and be declared in `UseCases.swift` file as a settable `var`, to allow injection in UnitTest environment.

Example: 

```swift
public protocol ProductsUseCaseType {
    func products() -> Observable<[Product]>
}

struct ProductsUseCase: ProductsUseCaseType {
    func products() -> Observable<[Product]> {
        return Repositories.products.products()
    }
}

struct UseCases {
    ...
    public var products: ProducsUseCaseType = ProductsUseCase()
    ...
}