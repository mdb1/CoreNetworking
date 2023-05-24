# CoreNetworking

[![Swift](https://github.com/mdb1/CoreNetworking/actions/workflows/swift.yml/badge.svg)](https://github.com/mdb1/CoreNetworking/actions/workflows/swift.yml)

A lightweight networking library.

# Usage
* Use HTTPClient.shared for executing your requests.
* You can change the default JsonDecoder if needed.
* If you want to toggle the verbosity of the prints to the console, change the value of the `logResponses` boolean in HTTPClient. It's `true` by default.

## Logging

### Success Decoding Example:

```swift
✅ ===> JSON Decoding start:
Model:
▿ CoreNetworkingTests.CatFact
  - fact: "The biggest wildcat today is the Siberian Tiger. It can be more than 12 feet (3.6 m) long (about the size of a small car) and weigh up to 700 pounds (317 kg)."
  - length: 158
Additional Info:
▿ 1 key/value pair
  ▿ (2 elements)
    - key: "UTF8 - String"
    - value: "{\"fact\":\"The biggest wildcat today is the Siberian Tiger. It can be more than 12 feet (3.6 m) long (about the size of a small car) and weigh up to 700 pounds (317 kg).\",\"length\":158}"
✅ <=== JSON Decoding end.
```

### Decoding Issue Example:

```swift
❌ ===> JSON Decoding issue start:
Error description: Key 'CodingKeys(stringValue: "fact", intValue: nil)' not found
Additional Info:
▿ 2 key/value pairs
  ▿ (2 elements)
    - key: "Model"
    - value: "CatFact"
  ▿ (2 elements)
    - key: "Context"
    - value: "No value associated with key CodingKeys(stringValue: \"fact\", intValue: nil) (\"fact\")."
❌ <=== JSON Decoding issue end.
```
