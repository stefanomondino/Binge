# Swiftlint

[SwiftLint](https://github.com/realm/SwiftLint) is a tool that enforces Swift best practices about how code is wrote and linted.

SwiftLint is integrated through pods and executed as build phase for the original Skeleton's `App` target. Its output is a list of warning or (sometimes) error directly inside xcode that will point out to developers where bad code (wrong spaces, too many new lines, wrong indentations, etc...) has been wrote.

SwiftLint can be configured inside the [config.swiftlint.yml](../config.swiftlint.yml) file.

To automatically correct every detected warning (where possible), simply run on simulator the `SwiftLint` scheme.