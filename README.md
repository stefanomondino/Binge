![img](./Sources/App/Supporting%20Files/Assets.xcassets/AppIcon.appiconset/ios-marketing.png =250x250)


This project is managed through [XcodeGen](https://github.com/yonaskolb/XcodeGen). No xcode project (or workspace) will be committed under source control, as they will always be recreated through automatic generation.
Every change to project (or Info.plist) must be handled through `project.yml` file.

## Secrets file
This project needs some secrets to be set, in order to work.
Those secrets cannot be shared publicly because they are tied to external services and subject to strict policies.

Secrets must be placed in `Configuration/Resources/Secrets.yml` with following structure:
```yaml
tmdbAPIKey: "<valid api key for TheMovieDatabase API"
fanartAPIKey: "<valid API key for Fanart.tv API>"
traktClientID: "<valid Traktv Client Secret from Trakt.tv"
traktClientSecret: "<valid Traktv Client Secret from Trakt.tv>"
traktRedirectURI: "<valid redirect URI for Trakt's OAUTH process>"
```
A `Secrets.swift` file will be properly generated during the setup phase

**Be sure those file are NEVER pushed into source control** 

## Project setup

This project is using a `Makefile` for proper configuration.

Environment variables can be used to customize project's name and bundle identifier.

Available commands are:

- `make clean`: performs a project cleanup by removing `xcodeproj`, `xcworkspace` and `Pods` folder.

- `make resources`: creates Generated resources swift file throuh [SwiftGen](https://github.com/SwiftGen/SwiftGen) 

- `make project`: generates project through [XcodeGen](https://github.com/yonaskolb/XcodeGen) and installs pods

- `make dependencies`: Executes a `pod install` command.

- `make setup`: Properly sets up project by installing tools, dependencies, generating resources and project, and eventually setting up git pre-commit hooks for automatic code linting



## Core components

Project follows the **MVVM** pattern, using **Routes** to handle navigation (something similar to Coordinators, but without any state involved).

The architecture is quite linear and use *observation* and *streams* provided by RxSwift's `Observable` to propagate changes.


