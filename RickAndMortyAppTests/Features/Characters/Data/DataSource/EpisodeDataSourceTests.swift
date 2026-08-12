import Testing
@testable import RickAndMortyApp

@Suite("EpisodeDataSource")
final class EpisodeDataSourceTests {
    private let apiClientSpy = APIClientSpy()
    private lazy var sut = EpisodeDataSource(apiClient: apiClientSpy)

    @Test
    func testGetEpisode_ExecutesRequestWithProvidedID() async throws {
        apiClientSpy.result = .success(EpisodeDTO.fixture())

        _ = try await sut.getEpisode(id: 7)

        let request = try #require(
            apiClientSpy.receivedRequest as? GetEpisodeRequest
        )
        #expect(request.episodeID == 7)
    }

    @Test
    func testGetEpisode_WhenClientSucceeds_ReturnsEpisode() async throws {
        apiClientSpy.result = .success(
            EpisodeDTO.fixture(id: 7, name: "Raising Gazorpazorp", episode: "S01E07")
        )

        let result = try await sut.getEpisode(id: 7)

        #expect(result.id == 7)
        #expect(result.name == "Raising Gazorpazorp")
        #expect(result.episode == "S01E07")
    }

    @Test
    func testGetEpisode_WhenClientFails_PropagatesAppError() async {
        apiClientSpy.result = .failure(AppError.noConnection)

        await #expect(throws: AppError.noConnection) {
            try await sut.getEpisode(id: 1)
        }
    }
}
