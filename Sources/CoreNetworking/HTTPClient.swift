import Foundation

/// The HTTPClient class.
public class HTTPClient {
    /// The shared instance.
    public static let shared = HTTPClient()
    /// Replace the default JSONDecoder if necessary.
    public var jsonDecoder: JSONDecoder = JSONDecoder()

    /// Executes a request asynchronously and returns a response, or throws an error.
    public func execute<Response: Decodable>(
        _ request: Request,
        responseType: Response.Type
    ) async throws -> Response {
        let (data, response) = try await URLSession.shared.data(
            for: request.urlRequest,
            delegate: nil
        )

        guard let response = response as? HTTPURLResponse else {
            throw Request.RequestError.noResponse
        }
        switch response.statusCode {
        case 200...299:
            guard let decodedResponse = try? jsonDecoder.decode(
                responseType,
                from: data
            ) else {
                throw Request.RequestError.decode
            }
            return decodedResponse
        case 401:
            throw Request.RequestError.unauthorized
        default:
            throw Request.RequestError.unexpectedStatusCode
        }
    }
}
