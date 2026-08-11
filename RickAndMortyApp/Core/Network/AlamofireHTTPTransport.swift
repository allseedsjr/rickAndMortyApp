import Foundation

final class AlamofireHTTPTransport: HTTPTransport {
    private let session: HTTPSession

    init(session: HTTPSession) {
        self.session = session
    }

    func execute(
        _ request: URLRequest
    ) async throws -> HTTPResponse {
        try await session.execute(request)
    }
}
