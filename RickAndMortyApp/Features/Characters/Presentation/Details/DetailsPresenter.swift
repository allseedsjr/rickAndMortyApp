@MainActor
protocol DetailsPresenting {
    func viewDidLoad()
    func retryFirstSeenIn()
    func didTapBack()
}

@MainActor
final class DetailsPresenter: DetailsPresenting {
    weak var view: (any DetailsDisplaying)?

    private let character: Character
    private let interactor: any DetailsInteracting
    private let mapper: any DetailsViewModelMapping
    private let errorMapper: any ErrorViewModelMapping
    private weak var router: (any DetailsRouting)?
    private var firstSeenInTask: Task<Void, Never>?

    init(
        character: Character,
        interactor: any DetailsInteracting,
        mapper: any DetailsViewModelMapping,
        errorMapper: any ErrorViewModelMapping,
        router: any DetailsRouting
    ) {
        self.character = character
        self.interactor = interactor
        self.mapper = mapper
        self.errorMapper = errorMapper
        self.router = router
    }

    deinit {
        firstSeenInTask?.cancel()
    }

    func viewDidLoad() {
        view?.showCharacter(mapper.map(character))
        loadFirstSeenIn()
    }

    func retryFirstSeenIn() {
        loadFirstSeenIn()
    }

    func didTapBack() {
        router?.showHome()
    }

    private func loadFirstSeenIn() {
        firstSeenInTask?.cancel()

        guard let episodeID = character.firstEpisodeID else {
            view?.showFirstSeenInUnavailable()
            return
        }

        view?.showFirstSeenInLoading()
        let interactor = interactor

        firstSeenInTask = Task { [weak self] in
            do {
                try Task.checkCancellation()
                let firstSeenIn = try await interactor.getFirstSeenIn(
                    episodeID: episodeID
                )
                try Task.checkCancellation()
                guard let self else { return }
                self.firstSeenInTask = nil
                self.view?.showFirstSeenIn(self.mapper.map(firstSeenIn))
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled, let self else { return }
                self.firstSeenInTask = nil
                self.view?.showFirstSeenInError(self.errorMapper.map(error))
            }
        }
    }
}
