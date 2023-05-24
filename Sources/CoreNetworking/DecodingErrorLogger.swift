//
//  DecodingErrorLogger.swift
//  
//
//  Created by Manu on 24/05/2023.
//

import Foundation

/// Logs error to the console when decoding network models.
struct DecodingErrorLogger {
    private let jsonDecoder: JSONDecoder

    init(
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.jsonDecoder = jsonDecoder
    }

    func logAdditionalDecodingFailureInfo(with error: Error, for type: Decodable.Type) {
        var errorDescription: String = ""
        var logProperties: [String: String] = [:]
        logProperties["Model"] = "\(type)"

        if let decodingError = error as? DecodingError {
            switch decodingError {
            case let .dataCorrupted(context):
                // An indication that the data is corrupted or otherwise invalid.
                addContext(context, logProperties: &logProperties)
                errorDescription = "Corrupted Data"
            case let .keyNotFound(key, context):
                // An indication that a keyed decoding container was asked for an entry for the given key,
                // but did not contain one.
                addContext(context, logProperties: &logProperties)
                errorDescription = "Key '\(key)' not found"
            case let .valueNotFound(value, context):
                // An indication that a non-optional value of the given type was expected, but a null value was found.
                addContext(context, logProperties: &logProperties)
                errorDescription = "Value '\(value)' not found"
            case let .typeMismatch(type, context):
                // An indication that a value of the given type could not be decoded because
                // it did not match the type of what was found in the encoded payload.
                addContext(context, logProperties: &logProperties)
                errorDescription = "Type '\(type)' mismatch"
            default: ()
            }
        }

        print("❌ ===> JSON Decoding issue start:")
        print("Error description: \(errorDescription)")
        print("Additional Info:")
        dump(logProperties)
        print("❌ <=== JSON Decoding issue end.")
        print("")
    }
}

private extension DecodingErrorLogger {
    /// Add Decoding Error context information to the dictionary.
    func addContext(
        _ context: DecodingError.Context,
        logProperties: inout [String: String]
    ) {
        logProperties["Context"] = context.debugDescription
        if context.codingPath.count > 0 {
            logProperties["Coding Path"] = context.codingPath.debugDescription
        }
        if let underlyingError = context.underlyingError {
            logProperties["Underlying Error"] = underlyingError.localizedDescription
        }
    }
}
