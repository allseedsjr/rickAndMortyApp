protocol ErrorViewModelMapping {
    func map(_ error: any Error) -> ErrorViewModel
}

struct ErrorViewModelMapper: ErrorViewModelMapping {
    private enum Strings {
        static let offlineTitle = "No internet connection"
        static let offlineMessage = "Check your connection and try again."
        static let timeoutTitle = "Request timed out"
        static let timeoutMessage = "The server took too long to respond. Please try again."
        static let rateLimitedTitle = "Too many requests"
        static let rateLimitedMessage = "Please wait a moment before trying again."
        static let unavailableTitle = "Service unavailable"
        static let unavailableMessage = "The service is temporarily unavailable. Please try again shortly."
        static let genericTitle = "Something went wrong"
        static let genericMessage = "Unable to complete the request. Please try again."
        static let invalidDataMessage = "We couldn't process the server response."
        static let accessDeniedMessage = "The service denied access to this request."
        static let notFoundMessage = "The requested content could not be found."
    }

    func map(_ error: any Error) -> ErrorViewModel {
        guard let error = error as? AppError else {
            return genericRetryableError
        }

        switch error {
        case .noConnection:
            return .init(
                title: Strings.offlineTitle,
                message: Strings.offlineMessage,
                allowsRetry: true
            )
        case .timeout:
            return .init(
                title: Strings.timeoutTitle,
                message: Strings.timeoutMessage,
                allowsRetry: true
            )
        case .rateLimited:
            return .init(
                title: Strings.rateLimitedTitle,
                message: Strings.rateLimitedMessage,
                allowsRetry: true
            )
        case .serviceUnavailable:
            return .init(
                title: Strings.unavailableTitle,
                message: Strings.unavailableMessage,
                allowsRetry: true
            )
        case .invalidData:
            return nonRetryableError(message: Strings.invalidDataMessage)
        case .accessDenied:
            return nonRetryableError(message: Strings.accessDeniedMessage)
        case .notFound:
            return nonRetryableError(message: Strings.notFoundMessage)
        case .unknown:
            return genericRetryableError
        }
    }

    private var genericRetryableError: ErrorViewModel {
        .init(
            title: Strings.genericTitle,
            message: Strings.genericMessage,
            allowsRetry: true
        )
    }

    private func nonRetryableError(message: String) -> ErrorViewModel {
        .init(
            title: Strings.genericTitle,
            message: message,
            allowsRetry: false
        )
    }
}
