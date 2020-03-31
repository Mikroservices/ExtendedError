# :beetle: ExtendedError

![Build Status](https://github.com/Mikroservices/ExtendedError/workflows/Build/badge.svg)
[![Swift 5.2](https://img.shields.io/badge/Swift-5.2-orange.svg?style=flat)](ttps://developer.apple.com/swift/)
[![Vapor 4](https://img.shields.io/badge/vapor-4.0-blue.svg?style=flat)](https://vapor.codes)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![Platforms OS X | Linux](https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat)](https://developer.apple.com/swift/)

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

## Getting started

You need to add library to `Package.swift` file:

 - add package to dependencies:
```swift
.package(url: "https://github.com/Mikroservices/ExtendedError.git", from: "2.0.0")
```

- and add product to your target:
```swift
.target(name: "App", dependencies: [
    .product(name: "Vapor", package: "vapor"),
    .product(name: "ExtendedError", package: "ExtendedError")
])
```

Then you can add middleware to Vapor:

```swift
import App
import Vapor
import ExtendedError

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)

let app = Application(env)

// Add error middleware.
let errorMiddleware = CustomErrorMiddleware()
app.middleware.use(errorMiddleware)

defer { app.shutdown() }

try configure(app)
try app.run()
```

## Developing

Download the source code and run in command line:

```bash
$ git clone https://github.com/Mikroservices/ExtendedError.git
$ swift package update
$ swift build
```
Run the following command if you want to open project in Xcode:

```bash
$ open Package.swift
```

## Contributing

You can fork and clone repository. Do your changes and pull a request.
