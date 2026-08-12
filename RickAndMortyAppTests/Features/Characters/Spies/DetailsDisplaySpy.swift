@testable import RickAndMortyApp

@MainActor
final class DetailsDisplaySpy: DetailsDisplaying {
    private(set) var shownCharacters: [DetailsViewModel] = []
    private(set) var loadingCallCount = 0
    private(set) var shownFirstSeenIn: [FirstSeenInViewModel] = []
    private(set) var unavailableCallCount = 0
    private(set) var shownErrors: [ErrorViewModel] = []
    var onShowFirstSeenIn: (() -> Void)?
    var onShowError: (() -> Void)?

    func showCharacter(_ viewModel: DetailsViewModel) {
        shownCharacters.append(viewModel)
    }

    func showFirstSeenInLoading() {
        loadingCallCount += 1
    }

    func showFirstSeenIn(_ viewModel: FirstSeenInViewModel) {
        shownFirstSeenIn.append(viewModel)
        onShowFirstSeenIn?()
    }

    func showFirstSeenInUnavailable() {
        unavailableCallCount += 1
    }

    func showFirstSeenInError(_ error: ErrorViewModel) {
        shownErrors.append(error)
        onShowError?()
    }
}
