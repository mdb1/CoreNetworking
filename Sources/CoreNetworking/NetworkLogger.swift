//
//  NetworkLogger.swift
//  
//
//  Created by Manu on 24/05/2023.
//

import Foundation

/// Logs networking information to the console.
public struct NetworkLogger {
    /// Configuration options.
    public enum Configuration {
        /// Verbose: logs requests/responses to the console based on the associated values.
        case verbose(logRequests: Bool, logResponses: Bool)
        /// Quiet: doesn't log anything.
        case quiet
    }

    private let configuration: Configuration

    /// Initializer.
    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    func logRequest(_ request: Request) {
        switch configuration {
        case let .verbose(logRequests, _):
            guard logRequests else { return }

            Current.logger.debug("""
            🛜 ===> Network Request started:
            \(request.logProperties.toJSONData()?.prettyPrintedJSONString)
            """)
        case .quiet:
            return
        }
    }

    func logResponse(_ response: HTTPURLResponse, request: Request) {
        switch configuration {
        case let .verbose(_, logResponses):
            guard logResponses else { return }
            var logProperties: [String: Any] = [:]
            logProperties["Request's Internal Id"] = request.internalId
            logProperties.merge(response.logProperties) { _, new in
                new
            }

            Current.logger.debug("""
            🛜 <==== Network Response received:"
            \(logProperties.toJSONData()?.prettyPrintedJSONString)
            """)

        case .quiet:
            return
        }
    }

    func logDecodingSuccessResponse(model: Decodable, for type: Decodable.Type, data: Data) {
        switch configuration {
        case let .verbose(_, logResponses):
            guard logResponses else { return }

            Current.logger.debug("""
            ✅ ==> JSON Decoding Success:
            ℹ️ 🔍 Expected Model: \(type)
            ℹ️ 📝 Pretty Printed JSON:
            \(data.prettyPrintedJSONString)
            """)
        case .quiet:
            return
        }
    }

    func logDecodingErrorResponse(with error: Error, for type: Decodable.Type, data: Data) {
        switch configuration {
        case let .verbose(_, logResponses):
            guard logResponses else { return }
            var errorDescription: String = ""
            var logProperties: [String: Any] = [:]

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

            Current.logger.error("""
            ❌ ==> JSON Decoding issue:
            Error description: \(errorDescription)
            ℹ️ 🔍 Expected Model: \(type)
            ℹ️ 📝 Pretty Printed JSON:
            \(data.prettyPrintedJSONString)
            ℹ️ 📝 Underlying decoding issue:
            \(logProperties.toJSONData()?.prettyPrintedJSONString)
            """)
        case .quiet:
            return
        }
    }
}

private extension NetworkLogger {
    /// Add Decoding Error context information to the dictionary.
    func addContext(
        _ context: DecodingError.Context,
        logProperties: inout [String: Any]
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
