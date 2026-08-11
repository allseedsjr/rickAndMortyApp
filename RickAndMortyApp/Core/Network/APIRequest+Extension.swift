import Foundation

extension APIRequest {
    var method: HTTPMethod {
        .get
    }

    var headers: [String: String] {
        [:]
    }

    var queryItems: [URLQueryItem] {
        []
    }
}
