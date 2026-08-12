@testable import RickAndMortyApp

@MainActor
final class HomeDisplaySpy: HomeDisplayLogic {
    var onShowCharacters: (() -> Void)?
    var onAppendCharacters: (() -> Void)?
    var onShowPaginationError: (() -> Void)?
    var onShowError: (() -> Void)?

    private(set) var showLoadingCallCount = 0
    private(set) var shownCharacters: [[CharacterCellViewModel]] = []
    private(set) var appendedCharacters: [[CharacterCellViewModel]] = []
    private(set) var searchEmptyStateVisibility: [Bool] = []
    private(set) var paginationLoadingStates: [Bool] = []
    private(set) var paginationErrors: [ErrorViewModel] = []
    private(set) var errors: [ErrorViewModel] = []
    private(set) var selectedCharacters: [Character] = []

    func displayLoading() {
        showLoadingCallCount += 1
    }

    func displayCharacters(_ characters: [CharacterCellViewModel]) {
        shownCharacters.append(characters)
        let callback = onShowCharacters
        onShowCharacters = nil
        callback?()
    }

    func displayAdditionalCharacters(_ characters: [CharacterCellViewModel]) {
        appendedCharacters.append(characters)
        let callback = onAppendCharacters
        onAppendCharacters = nil
        callback?()
    }

    func displaySearchEmptyState(_ isVisible: Bool) {
        searchEmptyStateVisibility.append(isVisible)
    }

    func displayPaginationLoading(_ isLoading: Bool) {
        paginationLoadingStates.append(isLoading)
    }

    func displayPaginationError(_ error: ErrorViewModel) {
        paginationErrors.append(error)
        let callback = onShowPaginationError
        onShowPaginationError = nil
        callback?()
    }

    func displayError(_ error: ErrorViewModel) {
        errors.append(error)
        let callback = onShowError
        onShowError = nil
        callback?()
    }

    func displaySelectedCharacter(_ character: Character) {
        selectedCharacters.append(character)
    }
}
