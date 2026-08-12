@testable import RickAndMortyApp

@MainActor
final class DetailsDisplaySpy: DetailsDisplayLogic {
    private(set) var displayedCharacters: [DetailsViewModel] = []
    private(set) var loadingCallCount = 0
    private(set) var displayedFirstSeenIn: [FirstSeenInViewModel] = []
    private(set) var unavailableCallCount = 0
    private(set) var displayedErrors: [ErrorViewModel] = []

    func displayCharacter(_ viewModel: DetailsViewModel) {
        displayedCharacters.append(viewModel)
    }

    func displayFirstSeenInLoading() {
        loadingCallCount += 1
    }

    func displayFirstSeenIn(_ viewModel: FirstSeenInViewModel) {
        displayedFirstSeenIn.append(viewModel)
    }

    func displayFirstSeenInUnavailable() {
        unavailableCallCount += 1
    }

    func displayFirstSeenInError(_ error: ErrorViewModel) {
        displayedErrors.append(error)
    }
}
