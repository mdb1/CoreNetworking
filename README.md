# CoreNetworking

[![Swift](https://github.com/mdb1/CoreNetworking/actions/workflows/swift.yml/badge.svg)](https://github.com/mdb1/CoreNetworking/actions/workflows/swift.yml)

A lightweight networking library.

# Usage
* Use HTTPClient.shared for executing your requests.
* You can change the default JsonDecoder if needed.

## Logging 
There is a `NetworkLogger` object, that, by default will print useful information about the requests and responses to the console.

If you don't want the logger, you can just override the object with a `quiet` configuration:
```swift
HTTPClient.shared.networkLogger = .init(configuration: .quiet)

// Or:
HTTPClient.shared.networkLogger = .init(
    configuration: .verbose(
        logRequests: true,  // Log requests
        logResponses: false // Doesn't log responses
    )
)
```

### Success Example:

![success](/resources/network-success.png)

### Decoding Issue Example:

![error](/resources/network-error.png)
