protocol ErrorViewModelMapping {
    func map(_ error: any Error) -> ErrorViewModel
}

struct ErrorViewModelMapper: ErrorViewModelMapping {
    func map(_ error: any Error) -> ErrorViewModel {
        guard let error = error as? AppError else {
            return genericRetryableError
        }

        switch error {
        case .noConnection:
            return .init(
                title: Strings.Error.offlineTitle,
                message: Strings.Error.offlineMessage,
                allowsRetry: true
            )
        case .timeout:
            return .init(
                title: Strings.Error.timeoutTitle,
                message: Strings.Error.timeoutMessage,
                allowsRetry: true
            )
        case .rateLimited:
            return .init(
                title: Strings.Error.rateLimitedTitle,
                message: Strings.Error.rateLimitedMessage,
                allowsRetry: true
            )
        case .serviceUnavailable:
            return .init(
                title: Strings.Error.serviceUnavailableTitle,
                message: Strings.Error.serviceUnavailableMessage,
                allowsRetry: true
            )
        case .invalidData:
            return nonRetryableError(message: Strings.Error.invalidDataMessage)
        case .accessDenied:
            return nonRetryableError(message: Strings.Error.accessDeniedMessage)
        case .notFound:
            return nonRetryableError(message: Strings.Error.notFoundMessage)
        case .unknown:
            return genericRetryableError
        }
    }

    private var genericRetryableError: ErrorViewModel {
        .init(
            title: Strings.Error.genericTitle,
            message: Strings.Error.genericMessage,
            allowsRetry: true
        )
    }

    private func nonRetryableError(message: String) -> ErrorViewModel {
        .init(
            title: Strings.Error.genericTitle,
            message: message,
            allowsRetry: false
        )
    }
}
