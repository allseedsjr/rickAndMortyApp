@testable import RickAndMortyApp

@MainActor
final class HomePresenterSpy: HomePresentationLogic {
    var onPresentCharacters: (() -> Void)?
    var onPresentAdditionalCharacters: (() -> Void)?
    var onPresentError: (() -> Void)?

    private(set) var presentLoadingCallCount = 0
    private(set) var presentedCharacters: [(characters: [Character], query: String)] = []
    private(set) var presentedAdditionalCharacters: [[Character]] = []
    private(set) var paginationLoadingStates: [Bool] = []
    private(set) var presentedErrors: [(error: any Error, isPagination: Bool)] = []
    private(set) var selectedCharacters: [Character] = []

    func presentLoading() { presentLoadingCallCount += 1 }

    func presentCharacters(_ characters: [Character], query: String) {
        presentedCharacters.append((characters, query))
        onPresentCharacters?()
        onPresentCharacters = nil
    }

    func presentAdditionalCharacters(_ characters: [Character]) {
        presentedAdditionalCharacters.append(characters)
        onPresentAdditionalCharacters?()
        onPresentAdditionalCharacters = nil
    }

    func presentPaginationLoading(_ isLoading: Bool) {
        paginationLoadingStates.append(isLoading)
    }

    func presentError(_ error: any Error, isPagination: Bool) {
        presentedErrors.append((error, isPagination))
        onPresentError?()
        onPresentError = nil
    }

    func presentSelectedCharacter(_ character: Character) {
        selectedCharacters.append(character)
    }
}
