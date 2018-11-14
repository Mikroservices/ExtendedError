# :beetle: ExtendedError

Custom error middleware for Vapor. You can send one additional field in response: `code`. Example:

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
