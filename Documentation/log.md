# Logging

Logging in XCode console should **NEVER** happen through `print()`. 

Please, use the `Logger` object instead (which internally can use `print`) but can be turned off and managed through log levels

To log a string, use
```swift 
Logger.log("MyMessage", logLevel: .verbose)
```

By manually changing the `Logger.log` implementation it should be possible to redirect log messages to a text file or to a remote service (not tested yet).

A custom tag can be used as third parameter to filter each message in XCode console. It's legit to edit provided implementation if a better formatting is needed.

**IMPORTANT**

Each target has its own logger (the `Logger.swift` file is the only one shared between the targets). Each log level should be configured in the bootstrap phase (by default is set to `.verbose` for development and to `.none`).