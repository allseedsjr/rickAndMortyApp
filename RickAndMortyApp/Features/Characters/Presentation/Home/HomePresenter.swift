@MainActor
protocol HomePresentationLogic {
    func presentLoading()
    func presentCharacters(_ characters: [Character], query: String)
    func presentAdditionalCharacters(_ characters: [Character])
    func presentPaginationLoading(_ isLoading: Bool)
    func presentError(_ error: any Error, isPagination: Bool)
    func presentSelectedCharacter(_ character: Character)
}

@MainActor
final class HomePresenter: HomePresentationLogic {
    weak var view: (any HomeDisplayLogic)?

    private let viewModelMapper: any CharacterCellViewModelMapping
    private let errorMapper: any ErrorViewModelMapping

    init(
        viewModelMapper: any CharacterCellViewModelMapping,
        errorMapper: any ErrorViewModelMapping
    ) {
        self.viewModelMapper = viewModelMapper
        self.errorMapper = errorMapper
    }

    func presentLoading() {
        view?.displayLoading()
    }

    func presentCharacters(_ characters: [Character], query: String) {
        view?.displayCharacters(characters.map(viewModelMapper.map))
        view?.displaySearchEmptyState(!query.isEmpty && characters.isEmpty)
    }

    func presentAdditionalCharacters(_ characters: [Character]) {
        view?.displayAdditionalCharacters(characters.map(viewModelMapper.map))
    }

    func presentPaginationLoading(_ isLoading: Bool) {
        view?.displayPaginationLoading(isLoading)
    }

    func presentError(_ error: any Error, isPagination: Bool) {
        let viewModel = errorMapper.map(error)
        if isPagination {
            view?.displayPaginationError(viewModel)
        } else {
            view?.displayError(viewModel)
        }
    }

    func presentSelectedCharacter(_ character: Character) {
        view?.displaySelectedCharacter(character)
    }
}
