@testable import RickAndMortyApp

final class EpisodeRepositorySpy: EpisodeRepositoryProtocol {
    private(set) var receivedIDs: [Int] = []
    var result: Result<Episode, Error> = .success(.fixture())

    func getEpisode(id: Int) async throws -> Episode {
        receivedIDs.append(id)
        return try result.get()
    }
}
