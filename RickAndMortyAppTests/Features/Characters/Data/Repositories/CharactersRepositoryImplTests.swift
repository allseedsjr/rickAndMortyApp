import Testing
@testable import RickAndMortyApp

@Suite("CharactersRepositoryImpl")
final class CharactersRepositoryImplTests {
    private let remoteDataSourceSpy = CharacterDataSourceSpy()
    private let cacheLoaderSpy = CacheFirstLoaderSpy<CharacterResponseDTO>()
    private lazy var sut = CharactersRepositoryImpl(
        remoteDataSource: remoteDataSourceSpy,
        cacheLoader: cacheLoaderSpy
    )

    @Test
    func testGetCharacters_WhenPageIsFirst_UsesFirstPageCacheKey() async throws {
        cacheLoaderSpy.result = .success(.fixture())

        _ = try await sut.getCharacters(page: 1)

        #expect(cacheLoaderSpy.receivedKeys == ["characters-page-1"])
        #expect(remoteDataSourceSpy.receivedPages.isEmpty)
    }

    @Test
    func testGetCharacters_WhenFirstPageRequiresRemote_FetchesAndMapsResponse() async throws {
        remoteDataSourceSpy.result = .success(
            .fixture(results: [.fixture(id: 7, name: "Squanchy")])
        )

        let result = try await sut.getCharacters(page: 1)

        #expect(remoteDataSourceSpy.receivedPages == [1])
        #expect(result.characters.first?.name == "Squanchy")
    }

    @Test
    func testGetCharacters_WhenPageIsAfterFirst_BypassesCache() async throws {
        remoteDataSourceSpy.result = .success(.fixture())

        _ = try await sut.getCharacters(page: 2)

        #expect(cacheLoaderSpy.receivedKeys.isEmpty)
        #expect(remoteDataSourceSpy.receivedPages == [2])
    }

    @Test
    func testGetCharacters_WhenLoaderFails_PropagatesError() async {
        cacheLoaderSpy.result = .failure(AppError.noConnection)

        await #expect(throws: AppError.noConnection) {
            try await sut.getCharacters(page: 1)
        }
    }
}
