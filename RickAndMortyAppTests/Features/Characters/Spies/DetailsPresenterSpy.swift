@testable import RickAndMortyApp

@MainActor
final class DetailsPresenterSpy: DetailsPresentationLogic {
    private(set) var presentedCharacters: [Character] = []
    private(set) var loadingCallCount = 0
    private(set) var presentedFirstSeenIn: [FirstSeenIn] = []
    private(set) var unavailableCallCount = 0
    private(set) var presentedErrors: [Error] = []
    var onPresentFirstSeenIn: (() -> Void)?
    var onPresentError: (() -> Void)?

    func presentCharacter(_ character: Character) {
        presentedCharacters.append(character)
    }

    func presentFirstSeenInLoading() {
        loadingCallCount += 1
    }

    func presentFirstSeenIn(_ firstSeenIn: FirstSeenIn) {
        presentedFirstSeenIn.append(firstSeenIn)
        onPresentFirstSeenIn?()
    }

    func presentFirstSeenInUnavailable() {
        unavailableCallCount += 1
    }

    func presentFirstSeenInError(_ error: any Error) {
        presentedErrors.append(error)
        onPresentError?()
    }
}
