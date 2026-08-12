@MainActor
protocol HomePresenting {
    func viewDidLoad()
    func retryInitialLoading()
}

@MainActor
protocol HomeDisplaying: AnyObject {
    func showLoading()
    func showCharacters(_ characters: [CharacterCellViewModel])
    func showError(message: String)
}

@MainActor
final class HomePresenter: HomePresenting {
    private enum Strings {
        static let genericError = "Unable to load characters. Please try again."
    }

    weak var view: (any HomeDisplaying)?

    private let interactor: any HomeInteracting
    private let viewModelMapper: any CharacterCellViewModelMapping
    private var requestGeneration = 0
    private var charactersTask: Task<Void, Never>?

    init(
        interactor: any HomeInteracting,
        viewModelMapper: any CharacterCellViewModelMapping
    ) {
        self.interactor = interactor
        self.viewModelMapper = viewModelMapper
    }

    deinit {
        charactersTask?.cancel()
    }

    func viewDidLoad() {
        charactersTask?.cancel()
        requestGeneration += 1
        view?.showLoading()

        let generation = requestGeneration
        let interactor = interactor
        charactersTask = Task { [weak self] in
            do {
                try Task.checkCancellation()
                let charactersPage = try await interactor.getCharacters(page: 1)
                try Task.checkCancellation()

                guard let self,
                      generation == requestGeneration else {
                    return
                }

                charactersTask = nil
                let viewModels = charactersPage.characters.map {
                    viewModelMapper.map($0)
                }
                view?.showCharacters(viewModels)
            } catch is CancellationError {
                return
            } catch {
                guard let self,
                      !Task.isCancelled,
                      generation == requestGeneration else {
                    return
                }

                charactersTask = nil
                view?.showError(message: Strings.genericError)
            }
        }
    }

    func retryInitialLoading() {
        viewDidLoad()
    }
}
