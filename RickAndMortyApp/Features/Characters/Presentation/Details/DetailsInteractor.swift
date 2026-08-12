@MainActor
protocol DetailsBusinessLogic {
    func loadDetails()
    func retryFirstSeenIn()
}

@MainActor
final class DetailsInteractor: DetailsBusinessLogic {
    private let character: Character
    private let getFirstSeenInUseCase: any GetFirstSeenInUseCasing
    private let presenter: any DetailsPresentationLogic
    private var firstSeenInTask: Task<Void, Never>?

    init(
        character: Character,
        getFirstSeenInUseCase: any GetFirstSeenInUseCasing,
        presenter: any DetailsPresentationLogic
    ) {
        self.character = character
        self.getFirstSeenInUseCase = getFirstSeenInUseCase
        self.presenter = presenter
    }

    deinit {
        firstSeenInTask?.cancel()
    }

    func loadDetails() {
        presenter.presentCharacter(character)
        loadFirstSeenIn()
    }

    func retryFirstSeenIn() {
        loadFirstSeenIn()
    }

    private func loadFirstSeenIn() {
        firstSeenInTask?.cancel()

        guard let episodeID = character.firstEpisodeID else {
            presenter.presentFirstSeenInUnavailable()
            return
        }

        presenter.presentFirstSeenInLoading()
        let useCase = getFirstSeenInUseCase

        firstSeenInTask = Task { [weak self] in
            do {
                try Task.checkCancellation()
                let firstSeenIn = try await useCase.execute(episodeID: episodeID)
                try Task.checkCancellation()
                self?.handleSuccess(firstSeenIn)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                self?.handleFailure(error)
            }
        }
    }

    private func handleSuccess(_ firstSeenIn: FirstSeenIn) {
        firstSeenInTask = nil
        presenter.presentFirstSeenIn(firstSeenIn)
    }

    private func handleFailure(_ error: any Error) {
        firstSeenInTask = nil
        presenter.presentFirstSeenInError(error)
    }
}
