import Foundation

enum HTTPSessionFailure: Error, Equatable {
    case cancelled
    case url(URLError.Code)
    case unknown
}
