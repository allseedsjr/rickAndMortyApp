enum AppError: Error, Equatable {
    case noConnection
    case timeout
    case rateLimited
    case serviceUnavailable
    case accessDenied
    case notFound
    case invalidData
    case unknown
}
