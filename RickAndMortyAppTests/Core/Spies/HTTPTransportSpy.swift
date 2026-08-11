import Foundation
@testable import RickAndMortyApp

@MainActor
final class HTTPTransportSpy: HTTPTransport {
    private(set) var receivedRequest: URLRequest?
    var result: Result<HTTPResponse, Error> = .failure(HTTPTransportSpyError.missingStub)

    func execute(
        _ request: URLRequest
    ) async throws -> HTTPResponse {
        receivedRequest = request
        return try result.get()
    }
}

private enum HTTPTransportSpyError: Error {
    case missingStub
}
