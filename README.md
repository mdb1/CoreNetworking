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

```swift
🛜 ===> Network Request started:
▿ 3 key/value pairs
  ▿ (2 elements)
    - key: "URL"
    - value: "https://catfact.ninja/fact/?"
  ▿ (2 elements)
    - key: "HTTP Method"
    - value: "GET"
  ▿ (2 elements)
    - key: "Request\'s Internal Id"
    - value: "[3E786]"
🛜 <==== Network Response received:
▿ 3 key/value pairs
  ▿ (2 elements)
    - key: "Request\'s Internal Id"
    - value: "[3E786]"
  ▿ (2 elements)
    - key: "URL"
    - value: "https://catfact.ninja/fact/?"
  ▿ (2 elements)
    - key: "Status Code"
    - value: "200"
✅ ==> JSON Decoding start:
▿ CoreNetworkingTests.CatFact
  - fact: "A cat\'s brain is more similar to a man\'s brain than that of a dog."
  - length: 66
ℹ️ Additional Info:
▿ 2 key/value pairs
  ▿ (2 elements)
    - key: "Expected Model"
    - value: "CatFact"
  ▿ (2 elements)
    - key: "UTF8 - String"
    - value: "{\"fact\":\"A cat\'s brain is more similar to a man\'s brain than that of a dog.\",\"length\":66}"
✅ <== JSON Decoding end.
🏁 <==== Network Request finished.
```

### Decoding Issue Example:

```swift
🛜 ===> Network Request started:
▿ 3 key/value pairs
  ▿ (2 elements)
    - key: "Request\'s Internal Id"
    - value: "[1C57E]"
  ▿ (2 elements)
    - key: "HTTP Method"
    - value: "GET"
  ▿ (2 elements)
    - key: "URL"
    - value: "https://catfact.ninja/facts/?"
🛜 <==== Network Response received:
▿ 3 key/value pairs
  ▿ (2 elements)
    - key: "Request\'s Internal Id"
    - value: "[1C57E]"
  ▿ (2 elements)
    - key: "URL"
    - value: "https://catfact.ninja/facts/?"
  ▿ (2 elements)
    - key: "Status Code"
    - value: "200"
❌ ==> JSON Decoding issue start:
Error description: Key 'CodingKeys(stringValue: "fact", intValue: nil)' not found
ℹ️ Additional Info:
▿ 3 key/value pairs
  ▿ (2 elements)
    - key: "UTF8 - String"
    - value: "{\"current_page\":1,\"data\":[{\"fact\":\"Unlike dogs, cats do not have a sweet tooth. Scientists believe this is due to a mutation in a key taste receptor.\",\"length\":114},{\"fact\":\"-}"
  ▿ (2 elements)
    - key: "Expected Model"
    - value: "CatFact"
  ▿ (2 elements)
    - key: "Context"
    - value: "No value associated with key CodingKeys(stringValue: \"fact\", intValue: nil) (\"fact\")."
❌ <== JSON Decoding issue end.
🏁 <==== Network Request finished.
```
