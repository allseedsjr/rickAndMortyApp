@testable import RickAndMortyApp

@MainActor
final class HomeDisplaySpy: HomeDisplaying {
    var onShowCharacters: (() -> Void)?
    var onAppendCharacters: (() -> Void)?
    var onShowPaginationError: (() -> Void)?
    var onShowError: (() -> Void)?

    private(set) var showLoadingCallCount = 0
    private(set) var shownCharacters: [[CharacterCellViewModel]] = []
    private(set) var appendedCharacters: [[CharacterCellViewModel]] = []
    private(set) var paginationLoadingStates: [Bool] = []
    private(set) var paginationErrorMessages: [String] = []
    private(set) var errorMessages: [String] = []

    func showLoading() {
        showLoadingCallCount += 1
    }

    func showCharacters(_ characters: [CharacterCellViewModel]) {
        shownCharacters.append(characters)
        onShowCharacters?()
    }

    func appendCharacters(_ characters: [CharacterCellViewModel]) {
        appendedCharacters.append(characters)
        onAppendCharacters?()
    }

    func showPaginationLoading(_ isLoading: Bool) {
        paginationLoadingStates.append(isLoading)
    }

    func showPaginationError(message: String) {
        paginationErrorMessages.append(message)
        onShowPaginationError?()
    }

    func showError(message: String) {
        errorMessages.append(message)
        onShowError?()
    }
}
