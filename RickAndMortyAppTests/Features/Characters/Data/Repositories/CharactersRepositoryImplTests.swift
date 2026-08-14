import Testing
@testable import RickAndMortyApp

@Suite("CharactersRepositoryImpl")
final class CharactersRepositoryImplTests {
    private let remoteDataSourceSpy = CharacterDataSourceSpy()
    private let cacheLoaderSpy = CacheFirstLoaderSpy<CharacterResponseDTO>()
    private let errorMapperSpy = AppErrorMapperSpy()
    private lazy var sut = CharactersRepositoryImpl(
        remoteDataSource: remoteDataSourceSpy,
        cacheLoader: cacheLoaderSpy,
        errorMapper: errorMapperSpy
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
    func testGetCharacters_WhenLoaderFails_MapsErrorToApplicationError() async {
        cacheLoaderSpy.result = .failure(NetworkError.noConnection)
        errorMapperSpy.result = AppError.noConnection

        await #expect(throws: AppError.noConnection) {
            try await sut.getCharacters(page: 1)
        }
        #expect(errorMapperSpy.receivedErrors.count == 1)
        #expect(errorMapperSpy.receivedErrors.first as? NetworkError == .noConnection)
    }

    @Test
    func testGetCharacters_WhenAdditionalPageFails_MapsErrorToApplicationError() async {
        remoteDataSourceSpy.result = .failure(NetworkError.timeout)
        errorMapperSpy.result = AppError.timeout

        await #expect(throws: AppError.timeout) {
            try await sut.getCharacters(page: 2)
        }
        #expect(errorMapperSpy.receivedErrors.count == 1)
        #expect(errorMapperSpy.receivedErrors.first as? NetworkError == .timeout)
    }
}
