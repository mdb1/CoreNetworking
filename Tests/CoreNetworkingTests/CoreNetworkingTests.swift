import XCTest
@testable import CoreNetworking

final class CoreNetworkingTests: XCTestCase {
    func testCorrectDecoding() async throws {
        let fetchFact = {
            try await HTTPClient.shared
                .execute(
                    .init(
                        urlString: "https://catfact.ninja/fact/",
                        method: .get([]),
                        headers: [:]
                    ),
                    responseType: CatFact.self
                )
        }
        let service = CatFactsService(dependencies: .init(fetchFact: fetchFact))
        let fact = try await service.fetchCatFact()
        XCTAssertNotNil(fact)
    }

    func testErrorDecoding() async throws {
        let fetchFact = {
            try await HTTPClient.shared
                .execute(
                    .init(
                        urlString: "https://catfact.ninja/facts/",
                        method: .get([]),
                        headers: [:]
                    ),
                    responseType: CatFact.self
                )
        }
        let service = CatFactsService(dependencies: .init(fetchFact: fetchFact))

        do {
            _ = try await service.fetchCatFact()
            XCTFail("Should have thrown")
        } catch let Request.RequestError.decode(DecodingError.keyNotFound(key, context)?) {
            XCTAssertEqual(key.intValue, nil)
            XCTAssertEqual(key.stringValue, "fact")
            XCTAssertEqual(context.codingPath.count, 0)
            XCTAssertEqual(
                context.debugDescription,
                "No value associated with key CodingKeys(stringValue: \"fact\", intValue: nil) (\"fact\")."
            )
            XCTAssertNil(context.underlyingError)
        } catch {
            XCTFail("Should have thrown RequestError.decode error")
        }
    }
}

final class CatFactsService {
    private let dependencies: Dependencies
    var fact: CatFact?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func fetchCatFact() async throws -> CatFact {
        return try await dependencies.fetchFact()
    }
}

extension CatFactsService {
    struct Dependencies {
        var fetchFact: () async throws -> CatFact
    }
}

struct CatFact: Decodable {
    let fact: String
    let length: Int
}
