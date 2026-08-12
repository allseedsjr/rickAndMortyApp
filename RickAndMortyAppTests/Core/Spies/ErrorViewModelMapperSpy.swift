@testable import RickAndMortyApp

final class ErrorViewModelMapperSpy: ErrorViewModelMapping {
    private(set) var receivedErrors: [any Error] = []
    var result = ErrorViewModel(
        title: "Expected title",
        message: "Expected message",
        allowsRetry: true
    )

    func map(_ error: any Error) -> ErrorViewModel {
        receivedErrors.append(error)
        return result
    }
}
