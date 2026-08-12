import Foundation

@MainActor
protocol HomeBusinessLogic {
    func loadInitialCharacters()
    func retryInitialLoading()
    func loadNextPage()
    func retryNextPage()
    func dismissPaginationError()
    func searchCharacters(with query: String)
    func selectCharacter(id: Int)
}

@MainActor
final class HomeInteractor: HomeBusinessLogic {
    private enum LoadingKind {
        case initial
        case pagination

        var replacesCharacters: Bool {
            self == .initial
        }
    }

    private let getCharactersUseCase: any GetCharactersUseCasing
    private let presenter: any HomePresentationLogic
    private let searchFilter: any CharacterSearchFiltering
    private var paginationState: any HomePaginationStateHandling
    private var charactersTask: Task<Void, Never>?
    private var requestGeneration = 0
    private var characters: [Character] = []
    private var searchQuery = ""

    init(
        getCharactersUseCase: any GetCharactersUseCasing,
        presenter: any HomePresentationLogic,
        paginationState: any HomePaginationStateHandling,
        searchFilter: any CharacterSearchFiltering
    ) {
        self.getCharactersUseCase = getCharactersUseCase
        self.presenter = presenter
        self.paginationState = paginationState
        self.searchFilter = searchFilter
    }

    deinit {
        charactersTask?.cancel()
    }

    func loadInitialCharacters() {
        charactersTask?.cancel()
        requestGeneration += 1
        let page = paginationState.startInitialLoading()
        presenter.presentLoading()
        loadCharacters(page: page, generation: requestGeneration, kind: .initial)
    }

    func retryInitialLoading() {
        loadInitialCharacters()
    }

    func loadNextPage() {
        guard let page = paginationState.startNextPageLoading() else { return }
        presenter.presentPaginationLoading(true)
        loadCharacters(page: page, generation: requestGeneration, kind: .pagination)
    }

    func retryNextPage() {
        guard paginationState.prepareRetry() else { return }
        loadNextPage()
    }

    func dismissPaginationError() {
        paginationState.dismissError()
    }

    func searchCharacters(with query: String) {
        searchQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        presentFilteredCharacters()
    }

    func selectCharacter(id: Int) {
        guard let character = characters.first(where: { $0.id == id }) else { return }
        presenter.presentSelectedCharacter(character)
    }

    private func loadCharacters(page: Int, generation: Int, kind: LoadingKind) {
        let useCase = getCharactersUseCase

        charactersTask = Task { [weak self] in
            do {
                try Task.checkCancellation()
                let pageResult = try await useCase.execute(page: page)
                try Task.checkCancellation()
                self?.handleSuccess(pageResult, page: page, generation: generation, kind: kind)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                self?.handleFailure(error, generation: generation, kind: kind)
            }
        }
    }

    private func handleSuccess(
        _ pageResult: CharactersPage,
        page: Int,
        generation: Int,
        kind: LoadingKind
    ) {
        guard generation == requestGeneration,
              paginationState.canHandleResponse(page: page) else { return }

        charactersTask = nil
        paginationState.finish(page: page, hasNextPage: pageResult.hasNextPage)

        if kind.replacesCharacters {
            characters = pageResult.characters
            presentFilteredCharacters()
        } else {
            characters.append(contentsOf: pageResult.characters)
            if searchQuery.isEmpty {
                presenter.presentAdditionalCharacters(pageResult.characters)
            } else {
                presentFilteredCharacters()
            }
        }
    }

    private func handleFailure(
        _ error: any Error,
        generation: Int,
        kind: LoadingKind
    ) {
        guard generation == requestGeneration else { return }

        charactersTask = nil
        let isPagination = kind == .pagination
        paginationState.fail(wasPagination: isPagination)
        presenter.presentPaginationLoading(false)
        presenter.presentError(error, isPagination: isPagination)
    }

    private func presentFilteredCharacters() {
        let filteredCharacters = searchFilter.filter(characters, by: searchQuery)
        presenter.presentCharacters(filteredCharacters, query: searchQuery)
    }
}
