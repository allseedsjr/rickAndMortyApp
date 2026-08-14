import Testing
@testable import RickAndMortyApp

@Suite("EpisodeRepositoryImpl")
final class EpisodeRepositoryImplTests {
    private let remoteDataSourceSpy = EpisodeDataSourceSpy()
    private let cacheLoaderSpy = CacheFirstLoaderSpy<EpisodeDTO>()
    private let errorMapperSpy = AppErrorMapperSpy()
    private lazy var sut = EpisodeRepositoryImpl(
        remoteDataSource: remoteDataSourceSpy,
        cacheLoader: cacheLoaderSpy,
        errorMapper: errorMapperSpy
    )

    @Test
    func testGetEpisode_UsesEpisodeIDAsCacheKey() async throws {
        cacheLoaderSpy.result = .success(.fixture(id: 12))

        _ = try await sut.getEpisode(id: 12)

        #expect(cacheLoaderSpy.receivedKeys == ["12"])
    }

    @Test
    func testGetEpisode_WhenLoaderRequiresRemote_FetchesAndMapsEpisode() async throws {
        remoteDataSourceSpy.result = .success(
            .fixture(id: 6, name: "Rick Potion #9", episode: "S01E06")
        )

        let result = try await sut.getEpisode(id: 6)

        #expect(remoteDataSourceSpy.receivedIDs == [6])
        #expect(result.id == 6)
        #expect(result.name == "Rick Potion #9")
        #expect(result.code == "S01E06")
    }

    @Test
    func testGetEpisode_WhenLoaderFails_MapsErrorToApplicationError() async {
        cacheLoaderSpy.result = .failure(NetworkError.timeout)
        errorMapperSpy.result = AppError.timeout

        await #expect(throws: AppError.timeout) {
            try await sut.getEpisode(id: 1)
        }
        #expect(errorMapperSpy.receivedErrors.count == 1)
        #expect(errorMapperSpy.receivedErrors.first as? NetworkError == .timeout)
    }
}
