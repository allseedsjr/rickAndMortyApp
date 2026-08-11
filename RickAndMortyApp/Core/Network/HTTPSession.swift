import Foundation

protocol HTTPSession {
    func execute(_ request: URLRequest) async throws -> HTTPResponse
}
