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
    private enum Strings {
        static let genericError = "Unable to load characters. Please try again."
    }

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
    private var paginationState: any HomePaginationStateHandling
    private var requestGeneration = 0
    private var charactersTask: Task<Void, Never>?
    private var characters: [CharacterCellViewModel] = []
    private var searchQuery = ""

    init(
        interactor: any HomeInteracting,
        viewModelMapper: any CharacterCellViewModelMapping,
        paginationState: any HomePaginationStateHandling,
        searchFilter: any CharacterSearchFiltering
    ) {
        self.interactor = interactor
        self.viewModelMapper = viewModelMapper
        self.paginationState = paginationState
        self.searchFilter = searchFilter
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

        let viewModels = charactersPage.characters.map {
            viewModelMapper.map($0)
        }
        if kind.replacesCharacters {
            characters = viewModels
            showFilteredCharacters()
        } else {
            characters.append(contentsOf: viewModels)

            if searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
        let filteredCharacters = searchFilter.filter(
            characters,
            by: normalizedQuery
        )

        view?.showCharacters(filteredCharacters)
        view?.showSearchEmptyState(
            !normalizedQuery.isEmpty && filteredCharacters.isEmpty
        )
    }

    private func handleFailure(
        generation: Int,
        kind: LoadingKind
    ) {
        guard generation == requestGeneration else {
            return
        }

        charactersTask = nil
        let wasPagination = kind == .pagination
        paginationState.fail(wasPagination: wasPagination)
        view?.showPaginationLoading(false)

        if wasPagination {
            view?.showPaginationError(message: Strings.genericError)
        } else {
            view?.showError(message: Strings.genericError)
        }
    }

}
