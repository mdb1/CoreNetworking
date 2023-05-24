import Foundation

/// The HTTPClient class.
public class HTTPClient {
    /// The shared instance.
    public static let shared = HTTPClient()
    /// Replace the default JSONDecoder if necessary.
    public var jsonDecoder: JSONDecoder = JSONDecoder()
    /// Determines if the HTTPClient will log information about the responses to the console.
    public var logResponses: Bool = true
    /// Console logger for successful decodes.
    private lazy var decodingSuccessLogger = DecodingSuccessLogger()
    /// Console logger for decoding issues.
    private lazy var decodingErrorLogger = DecodingErrorLogger(jsonDecoder: jsonDecoder)

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
            do {
                let decodedResponse = try jsonDecoder.decode(
                    responseType,
                    from: data
                )

                if logResponses {
                    decodingSuccessLogger.logInfo(model: decodedResponse, data: data)
                }
                
                return decodedResponse
            } catch {
                if logResponses {
                    decodingErrorLogger.logAdditionalDecodingFailureInfo(with: error, for: responseType)
                }

                guard let decodingError = error as? DecodingError else {
                    throw Request.RequestError.decode()
                }

                throw Request.RequestError.decode(decodingError)
            }
        case 401:
            throw Request.RequestError.unauthorized
        default:
            throw Request.RequestError.unexpectedStatusCode
        }
    }
}
