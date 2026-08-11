enum NetworkError: Error, Equatable {
    case invalidURL
    case http(statusCode: Int)
    case timeout
    case noConnection
    case cancelled
    case decoding
    case transport
}
