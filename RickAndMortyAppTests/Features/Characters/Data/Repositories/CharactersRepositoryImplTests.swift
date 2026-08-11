import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("CharactersRepositoryImpl", .serialized)
final class CharactersRepositoryImplTests {
    private let remoteDataSourceSpy = CharacterDataSourceSpy()
    private let localDataSourceSpy = CharacterLocalDataSourceSpy()
    private let dateProviderStub = DateProviderStub(
        now: Date(timeIntervalSince1970: 1_000)
    )
    private lazy var sut = CharactersRepositoryImpl(
        remoteDataSource: remoteDataSourceSpy,
        localDataSource: localDataSourceSpy,
        cachePolicy: CharacterCachePolicy(ttl: 120),
        dateProvider: dateProviderStub
    )

    @Test
    func testGetCharacters_WhenFirstPageCacheIsValid_ReturnsCachedPage() async throws {
        localDataSourceSpy.loadResult = .success(
            .fixture(
                response: .fixture(
                    results: [.fixture(id: 7, name: "Cached Squanchy")]
                ),
                createdAt: dateProviderStub.now.addingTimeInterval(-119)
            )
        )

        let page = try await sut.getCharacters(page: 1)

        #expect(page.characters.first?.id == 7)
        #expect(page.characters.first?.name == "Cached Squanchy")
        #expect(remoteDataSourceSpy.receivedPages.isEmpty)
        #expect(localDataSourceSpy.receivedResponses.isEmpty)
    }

    @Test
    func testGetCharacters_WhenFirstPageCacheDoesNotExist_FetchesAndSavesRemoteResponse() async throws {
        let response = CharacterResponseDTO.fixture(
            results: [.fixture(id: 8, name: "Remote Morty")]
        )
        localDataSourceSpy.loadResult = .success(nil)
        remoteDataSourceSpy.result = .success(response)

        let page = try await sut.getCharacters(page: 1)

        #expect(remoteDataSourceSpy.receivedPages == [1])
        #expect(page.characters.first?.id == 8)
        #expect(page.characters.first?.name == "Remote Morty")
        #expect(localDataSourceSpy.receivedResponses.first?.results.first?.id == 8)
        #expect(localDataSourceSpy.receivedCreationDates == [dateProviderStub.now])
    }

    @Test
    func testGetCharacters_WhenFirstPageCacheIsExpired_FetchesAndReplacesCache() async throws {
        localDataSourceSpy.loadResult = .success(
            .fixture(
                response: .fixture(results: [.fixture(id: 1, name: "Stale Rick")]),
                createdAt: dateProviderStub.now.addingTimeInterval(-120)
            )
        )
        remoteDataSourceSpy.result = .success(
            .fixture(results: [.fixture(id: 2, name: "Fresh Morty")])
        )

        let page = try await sut.getCharacters(page: 1)

        #expect(remoteDataSourceSpy.receivedPages == [1])
        #expect(page.characters.first?.id == 2)
        #expect(page.characters.first?.name == "Fresh Morty")
        #expect(localDataSourceSpy.receivedResponses.count == 1)
        #expect(localDataSourceSpy.receivedResponses.first?.results.first?.id == 2)
    }

    @Test
    func testGetCharacters_WhenCacheLoadingFails_FetchesRemoteResponse() async throws {
        localDataSourceSpy.loadResult = .failure(
            CharactersRepositoryImplTestError.localFailure
        )
        remoteDataSourceSpy.result = .success(.fixture())

        _ = try await sut.getCharacters(page: 1)

        #expect(remoteDataSourceSpy.receivedPages == [1])
    }

    @Test
    func testGetCharacters_WhenCacheSavingFails_ReturnsRemotePage() async throws {
        localDataSourceSpy.loadResult = .success(nil)
        localDataSourceSpy.saveError = CharactersRepositoryImplTestError.localFailure
        remoteDataSourceSpy.result = .success(
            .fixture(results: [.fixture(id: 2, name: "Morty Smith")])
        )

        let page = try await sut.getCharacters(page: 1)

        #expect(page.characters.first?.id == 2)
        #expect(page.characters.first?.name == "Morty Smith")
        #expect(localDataSourceSpy.receivedResponses.count == 1)
    }

    @Test
    func testGetCharacters_WhenCacheIsExpiredAndRemoteFails_PropagatesRemoteError() async {
        localDataSourceSpy.loadResult = .success(
            .fixture(
                createdAt: dateProviderStub.now.addingTimeInterval(-121)
            )
        )
        remoteDataSourceSpy.result = .failure(NetworkError.timeout)

        await #expect(throws: NetworkError.timeout) {
            try await sut.getCharacters(page: 1)
        }

        #expect(localDataSourceSpy.receivedResponses.isEmpty)
    }

    @Test
    func testGetCharacters_WhenPageIsAfterFirst_BypassesCacheAndDoesNotSave() async throws {
        localDataSourceSpy.loadResult = .success(.fixture())
        remoteDataSourceSpy.result = .success(.fixture())

        _ = try await sut.getCharacters(page: 3)

        #expect(remoteDataSourceSpy.receivedPages == [3])
        #expect(localDataSourceSpy.loadCallCount == 0)
        #expect(localDataSourceSpy.receivedResponses.isEmpty)
    }
}

private enum CharactersRepositoryImplTestError: Error {
    case localFailure
}
