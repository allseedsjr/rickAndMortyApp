import Foundation

@MainActor
protocol HomePresenting {
    func viewDidLoad()
    func retryInitialLoading()
    func loadNextPage()
    func retryNextPage()
    func dismissPaginationError()
    func searchCharacters(with query: String)
}

@MainActor
final class HomePresenter: HomePresenting {
    private enum LoadingKind {
        case initial
        case pagination

        var replacesCharacters: Bool {
            self == .initial
        }
    }

    weak var view: (any HomeDisplaying)?

    private let interactor: any HomeInteracting
    private let viewModelMapper: any CharacterCellViewModelMapping
    private let searchFilter: any CharacterSearchFiltering
    private let errorMapper: any ErrorViewModelMapping
    private var paginationState: any HomePaginationStateHandling
    private var requestGeneration = 0
    private var charactersTask: Task<Void, Never>?
    private var characters: [Character] = []
    private var searchQuery = ""

    init(
        interactor: any HomeInteracting,
        viewModelMapper: any CharacterCellViewModelMapping,
        paginationState: any HomePaginationStateHandling,
        searchFilter: any CharacterSearchFiltering,
        errorMapper: any ErrorViewModelMapping
    ) {
        self.interactor = interactor
        self.viewModelMapper = viewModelMapper
        self.paginationState = paginationState
        self.searchFilter = searchFilter
        self.errorMapper = errorMapper
    }

    deinit {
        charactersTask?.cancel()
    }

    func viewDidLoad() {
        charactersTask?.cancel()
        requestGeneration += 1
        let page = paginationState.startInitialLoading()
        view?.showLoading()

        let generation = requestGeneration
        loadCharacters(
            page: page,
            generation: generation,
            kind: .initial
        )
    }

    func retryInitialLoading() {
        viewDidLoad()
    }

    func loadNextPage() {
        guard let nextPage = paginationState.startNextPageLoading() else {
            return
        }

        view?.showPaginationLoading(true)

        let generation = requestGeneration
        loadCharacters(
            page: nextPage,
            generation: generation,
            kind: .pagination
        )
    }

    func retryNextPage() {
        guard paginationState.prepareRetry() else {
            return
        }

        loadNextPage()
    }

    func dismissPaginationError() {
        paginationState.dismissError()
    }

    func searchCharacters(with query: String) {
        searchQuery = query
        showFilteredCharacters()
    }

    private func loadCharacters(
        page: Int,
        generation: Int,
        kind: LoadingKind
    ) {
        let interactor = interactor

        charactersTask = Task { [weak self] in
            do {
                try Task.checkCancellation()
                let charactersPage = try await interactor.getCharacters(
                    page: page
                )

                try Task.checkCancellation()

                self?.handleSuccess(
                    charactersPage,
                    page: page,
                    generation: generation,
                    kind: kind
                )
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else {
                    return
                }

                self?.handleFailure(
                    error,
                    generation: generation,
                    kind: kind
                )
            }
        }
    }

    private func handleSuccess(
        _ charactersPage: CharactersPage,
        page: Int,
        generation: Int,
        kind: LoadingKind
    ) {
        guard generation == requestGeneration,
              paginationState.canHandleResponse(page: page) else {
            return
        }

        charactersTask = nil
        paginationState.finish(
            page: page,
            hasNextPage: charactersPage.hasNextPage
        )

        if kind.replacesCharacters {
            characters = charactersPage.characters
            showFilteredCharacters()
        } else {
            characters.append(contentsOf: charactersPage.characters)

            if searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let viewModels = charactersPage.characters.map {
                    viewModelMapper.map($0)
                }
                view?.appendCharacters(viewModels)
            } else {
                showFilteredCharacters()
            }
        }
    }

    private func showFilteredCharacters() {
        let normalizedQuery = searchQuery.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let viewModels = characters.map {
            viewModelMapper.map($0)
        }
        let filteredCharacters = searchFilter.filter(
            viewModels,
            by: normalizedQuery
        )

        view?.showCharacters(filteredCharacters)
        view?.showSearchEmptyState(
            !normalizedQuery.isEmpty && filteredCharacters.isEmpty
        )
    }

    private func handleFailure(
        _ error: any Error,
        generation: Int,
        kind: LoadingKind
    ) {
        guard generation == requestGeneration else {
            return
        }

        charactersTask = nil
        let wasPagination = kind == .pagination
        let errorViewModel = errorMapper.map(error)
        paginationState.fail(wasPagination: wasPagination)
        view?.showPaginationLoading(false)

        if wasPagination {
            view?.showPaginationError(errorViewModel)
        } else {
            view?.showError(errorViewModel)
        }
    }

}
