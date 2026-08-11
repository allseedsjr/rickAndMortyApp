import Foundation

protocol HTTPTransport {
    func execute(
        _ request: URLRequest
    ) async throws -> HTTPResponse
}
