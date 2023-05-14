import Foundation

/// Request object.
public struct Request {
    private let urlString: String
    private let method: HttpMethod
    private var headers: [String: String]

    /// Public initializer.
    public init(
        urlString: String,
        method: HttpMethod,
        headers: [String: String] = [:]
    ) {
        self.urlString = urlString
        self.method = method
        self.headers = headers
    }

    var urlRequest: URLRequest {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        var request = URLRequest(url: url)

        switch method {
        case .post(let data), .put(let data):
            request.httpBody = data
        case let .get(queryItems):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                preconditionFailure("Couldn't create a url from components...")
            }
            request = URLRequest(url: url)
        default:
            break
        }

        request.allHTTPHeaderFields = headers
        request.httpMethod = method.name
        return request
    }
}

public extension Request {
    enum HttpMethod: Equatable {
        case get([URLQueryItem])
        case put(Data?)
        case post(Data?)
        case patch

        var name: String {
            switch self {
            case .get: return "GET"
            case .put: return "PUT"
            case .post: return "POST"
            case .patch: return "PATCH"
            }
        }
    }

    enum RequestError: Error {
        case decode(DecodingError? = nil)
        case noResponse
        case unauthorized
        case unexpectedStatusCode

        var customMessage: String {
            switch self {
            case .decode(let underlyingError):
                return "Decode error: \(String(describing: underlyingError))"
            case .unauthorized:
                return "Session expired"
            default:
                return "Unknown error"
            }
        }
    }
}
