@testable import RickAndMortyApp

final class DetailsInteractorSpy: DetailsInteracting {
    private(set) var receivedEpisodeIDs: [Int] = []
    var result: Result<FirstSeenIn, Error> = .success(.fixture())

    func getFirstSeenIn(episodeID: Int) async throws -> FirstSeenIn {
        receivedEpisodeIDs.append(episodeID)
        return try result.get()
    }
}
