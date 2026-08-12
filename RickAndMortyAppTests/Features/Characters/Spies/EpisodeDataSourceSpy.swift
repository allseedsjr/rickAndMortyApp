@testable import RickAndMortyApp

final class EpisodeDataSourceSpy: EpisodeDataSourceProtocol {
    private(set) var receivedIDs: [Int] = []
    var result: Result<EpisodeDTO, Error> = .success(.fixture())

    func getEpisode(id: Int) async throws -> EpisodeDTO {
        receivedIDs.append(id)
        return try result.get()
    }
}
