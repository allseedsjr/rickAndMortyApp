import Testing
@testable import RickAndMortyApp

@Suite("GetFirstSeenInUseCase")
final class GetFirstSeenInUseCaseTests {
    private let repositorySpy = EpisodeRepositorySpy()
    private lazy var sut = GetFirstSeenInUseCase(repository: repositorySpy)

    @Test
    func testExecute_ForwardsEpisodeIDToRepository() async throws {
        _ = try await sut.execute(episodeID: 9)

        #expect(repositorySpy.receivedIDs == [9])
    }

    @Test
    func testExecute_WhenRepositorySucceeds_ReturnsFirstSeenIn() async throws {
        let expectedDate = "January 13, 2014"
        repositorySpy.result = .success(
            .fixture(
                name: "Something Ricked This Way Comes",
                code: "S01E09",
                airDate: expectedDate
            )
        )

        let result = try await sut.execute(episodeID: 9)

        #expect(result.episodeName == "Something Ricked This Way Comes")
        #expect(result.episodeCode == "S01E09")
        #expect(result.airDate == expectedDate)
    }

    @Test
    func testExecute_WhenRepositoryFails_PropagatesAppError() async {
        repositorySpy.result = .failure(AppError.serviceUnavailable)

        await #expect(throws: AppError.serviceUnavailable) {
            try await sut.execute(episodeID: 9)
        }
    }
}
