# Architecture

Skeleton implements applications through MVVM (**Model** - **View** - **ViewModel**) pattern. 

In order to properly implement this pattern, the whole application is composed of:

- `Model` crossplatform framework target
- `ViewModel` crossplatform framework target
- One starting iOS `App` application target.

**Important**: *a **crossplatform** framework can be compiled against, at least, iOS and tvOS, and also watchOS if possible*

During the development process, it's **critical** that :
- `Model`framework **NEVER** reference (import) neither App or ViewModel
- `ViewModel`framework **NEVER** reference (import) App
- `App` can import `ViewModel` almost everywhere, and `Model` only in configuration files

A single project can have more than one `App` target.
A new `App` target is needed when:

- The same project has an iOS app and/or a tvOS/watchOS app
- The same project needs to have more than one iOS (or same platform) app with different bundles (colors, assets, etc.) (usually called **WhiteLabel** apps: same app is re-skinned for different clients)
- The same project has two different apps that shares part of the screens and logic, but have some big differences (example: a customer app and a merchant app, with same styles but some different screens)

There's no need for a new `App` when.

- More than one *environment* is needed (dev, staging, production) - Project's **Configurations** must be used.
- Same app needs to be deployed with different **Bundle ID**s - As before, add a configuration and use  specific .xcconfig files