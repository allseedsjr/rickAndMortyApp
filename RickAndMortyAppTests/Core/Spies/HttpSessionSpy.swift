import Foundation
@testable import RickAndMortyApp

@MainActor
final class HTTPSessionSpy: HTTPSession {
    private(set) var receivedRequest: URLRequest?
    var result: Result<HTTPResponse, Error> = .failure(HTTPSessionSpyError.missingStub)

    func execute(
        _ request: URLRequest
    ) async throws -> HTTPResponse {
        receivedRequest = request
        return try result.get()
    }
}

private enum HTTPSessionSpyError: Error {
    case missingStub
}
