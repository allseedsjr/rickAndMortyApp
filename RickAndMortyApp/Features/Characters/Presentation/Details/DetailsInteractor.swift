protocol DetailsInteracting {
    func getFirstSeenIn(episodeID: Int) async throws -> FirstSeenIn
}

final class DetailsInteractor: DetailsInteracting {
    private let getFirstSeenInUseCase: any GetFirstSeenInUseCasing

    init(getFirstSeenInUseCase: any GetFirstSeenInUseCasing) {
        self.getFirstSeenInUseCase = getFirstSeenInUseCase
    }

    func getFirstSeenIn(episodeID: Int) async throws -> FirstSeenIn {
        try await getFirstSeenInUseCase.execute(episodeID: episodeID)
    }
}
