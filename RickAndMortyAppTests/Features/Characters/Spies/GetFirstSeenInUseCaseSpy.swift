@testable import RickAndMortyApp

final class GetFirstSeenInUseCaseSpy: GetFirstSeenInUseCasing {
    private(set) var receivedEpisodeIDs: [Int] = []
    var result: Result<FirstSeenIn, Error> = .failure(
        GetFirstSeenInUseCaseSpyError.missingStub
    )

    func execute(episodeID: Int) async throws -> FirstSeenIn {
        receivedEpisodeIDs.append(episodeID)
        return try result.get()
    }
}

private enum GetFirstSeenInUseCaseSpyError: Error {
    case missingStub
}
