protocol GetFirstSeenInUseCasing {
    func execute(episodeID: Int) async throws -> FirstSeenIn
}

final class GetFirstSeenInUseCase: GetFirstSeenInUseCasing {
    private let repository: any EpisodeRepositoryProtocol

    init(repository: any EpisodeRepositoryProtocol) {
        self.repository = repository
    }

    func execute(episodeID: Int) async throws -> FirstSeenIn {
        let episode = try await repository.getEpisode(id: episodeID)
        return FirstSeenIn(episode: episode)
    }
}
