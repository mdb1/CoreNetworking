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
    - key: "Request\'s Internal Id"
    - value: "[CA5C3]"
  ▿ (2 elements)
    - key: "URL"
    - value: "https://catfact.ninja/fact/?"
  ▿ (2 elements)
    - key: "HTTP Method"
    - value: "GET"
🛜 <==== Network Response received:
▿ 3 key/value pairs
  ▿ (2 elements)
    - key: "Status Code"
    - value: "200"
  ▿ (2 elements)
    - key: "Request\'s Internal Id"
    - value: "[CA5C3]"
  ▿ (2 elements)
    - key: "URL"
    - value: "https://catfact.ninja/fact/?"
✅ ==> JSON Decoding start:
▿ CoreNetworkingTests.CatFact
  - fact: "Cats are now Britain\'s favourite pet: there are 7.7 million cats as opposed to 6.6 million dogs."
  - length: 96
ℹ️ Additional Info:
ℹ️ 🔍 Expected Model: CatFact
ℹ️ 📝 Pretty Printed JSON:
{
  "fact" : "Cats are now Britain's favourite pet: there are 7.7 million cats as opposed to 6.6 million dogs.",
  "length" : 96
}
✅ <== JSON Decoding end.
🏁 <==== Network Request finished.
```

### Decoding Issue Example:

```swift
🛜 ===> Network Request started:
▿ 3 key/value pairs
  ▿ (2 elements)
    - key: "HTTP Method"
    - value: "GET"
  ▿ (2 elements)
    - key: "Request\'s Internal Id"
    - value: "[79B5E]"
  ▿ (2 elements)
    - key: "URL"
    - value: "https://catfact.ninja/facts/?"
🛜 <==== Network Response received:
▿ 3 key/value pairs
  ▿ (2 elements)
    - key: "Request\'s Internal Id"
    - value: "[79B5E]"
  ▿ (2 elements)
    - key: "Status Code"
    - value: "200"
  ▿ (2 elements)
    - key: "URL"
    - value: "https://catfact.ninja/facts/?"
❌ ==> JSON Decoding issue start:
Error description: Key 'CodingKeys(stringValue: "fact", intValue: nil)' not found
ℹ️ Additional Info:
ℹ️ 🔍 Expected Model: CatFact
ℹ️ 📝 Pretty Printed JSON:
{
  "last_page_url" : "https:\/\/catfact.ninja\/facts?page=34",
  "prev_page_url" : null,
  "from" : 1,
  "total" : 332,
  "path" : "https:\/\/catfact.ninja\/facts",
  "first_page_url" : "https:\/\/catfact.ninja\/facts?page=1",
  "last_page" : 34,
  "next_page_url" : "https:\/\/catfact.ninja\/facts?page=2",
  "current_page" : 1,
  "per_page" : 10,
  "to" : 10
}
▿ 1 key/value pair
  ▿ (2 elements)
    - key: "Context"
    - value: "No value associated with key CodingKeys(stringValue: \"fact\", intValue: nil) (\"fact\")."
❌ <== JSON Decoding issue end.
🏁 <==== Network Request finished.
```
