# :beetle: ExtendedError

Custom error middleware for Vapor. Thanks to this extended error you can create errors with additional field:  `code`. Example:

```swift
throw Terminate(.badRequest, code: "unknownError", reason: "Unknown error occured.")
```

Thanks to this to client will be send below JSON:

```json
{
    "error": true,
    "code": "unknownError",
    "reason": "Unknown error occured."
}
```

This is super important if you want to show user custom message based on `code` key (for example in different languages). 

## Registering in Vapor

```swift
/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config

    // Catches errors and converts to HTTP response
    services.register(CustomErrorMiddleware.self)
    middlewares.use(CustomErrorMiddleware.self)

    services.register(middlewares)
}
```

## Developing

Downloading source code and building in command line:

```bash
$ git clone https://github.com/Letterer/ExtendedError.git
$ swift package update
$ swift build
```
Opening project in XCode:

```bash
$ swift package generate-xcodeproj
$ open ExtendedError.xcodeproj
```

## Contributing

You can fork and clone repository. Do your changes and pull a request.
