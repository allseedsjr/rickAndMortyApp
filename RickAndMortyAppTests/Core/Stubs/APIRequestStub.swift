import Foundation
@testable import RickAndMortyApp

struct APIRequestStub: APIRequest {
    typealias Response = APIResponseStub

    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let queryItems: [URLQueryItem]

    init(
        path: String = "/characters",
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem] = []
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
    }
}
