import Testing
@testable import RickAndMortyApp

@Suite("EpisodeRepositoryImpl")
final class EpisodeRepositoryImplTests {
    private let dataSourceSpy = EpisodeDataSourceSpy()
    private lazy var sut = EpisodeRepositoryImpl(dataSource: dataSourceSpy)

    @Test
    func testGetEpisode_ForwardsIDToDataSource() async throws {
        _ = try await sut.getEpisode(id: 12)
        #expect(dataSourceSpy.receivedIDs == [12])
    }

    @Test
    func testGetEpisode_WhenDataSourceSucceeds_ReturnsMappedEpisode() async throws {
        dataSourceSpy.result = .success(
            .fixture(id: 6, name: "Rick Potion #9", episode: "S01E06")
        )

        let result = try await sut.getEpisode(id: 6)

        #expect(result.id == 6)
        #expect(result.name == "Rick Potion #9")
        #expect(result.code == "S01E06")
    }

    @Test
    func testGetEpisode_WhenDataSourceFails_PropagatesAppError() async {
        dataSourceSpy.result = .failure(AppError.timeout)

        await #expect(throws: AppError.timeout) {
            try await sut.getEpisode(id: 1)
        }
    }
}
