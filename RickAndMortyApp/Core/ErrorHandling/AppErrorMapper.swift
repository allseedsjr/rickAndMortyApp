import Foundation

protocol AppErrorMapping {
    func map(_ error: any Error) -> any Error
}

struct AppErrorMapper: AppErrorMapping {
    func map(_ error: any Error) -> any Error {
        if error is CancellationError {
            return CancellationError()
        }

        guard let networkError = error as? NetworkError else {
            return AppError.unknown
        }

        switch networkError {
        case .noConnection:
            return AppError.noConnection
        case .timeout:
            return AppError.timeout
        case .decoding, .invalidURL:
            return AppError.invalidData
        case .cancelled:
            return CancellationError()
        case .http(let statusCode):
            return map(statusCode: statusCode)
        case .transport:
            return AppError.unknown
        }
    }

    private func map(statusCode: Int) -> AppError {
        switch statusCode {
        case 401, 403:
            return .accessDenied
        case 404:
            return .notFound
        case 429:
            return .rateLimited
        case 500...599:
            return .serviceUnavailable
        default:
            return .unknown
        }
    }
}
