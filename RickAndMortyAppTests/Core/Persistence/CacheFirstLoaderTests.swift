import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("CacheFirstLoader", .serialized)
final class CacheFirstLoaderTests {
    private let storeSpy = CacheStoreSpy<CharacterResponseDTO>()
    private let dateProviderStub = DateProviderStub(
        now: Date(timeIntervalSince1970: 10_000)
    )
    private lazy var sut = CacheFirstLoader(
        store: storeSpy,
        policy: CachePolicy(ttl: 120),
        dateProvider: dateProviderStub
    )

    @Test
    func testLoad_WhenCacheIsValid_ReturnsCacheWithoutRemoteCall() async throws {
        storeSpy.loadResult = .success(
            CacheEntry(
                value: .fixture(results: [.fixture(id: 1, name: "Cached")]),
                createdAt: dateProviderStub.now.addingTimeInterval(-60)
            )
        )
        var remoteCallCount = 0

        let result = try await sut.load(key: "episode-1") {
            remoteCallCount += 1
            return .fixture(results: [.fixture(id: 1, name: "Remote")])
        }

        #expect(result.results.first?.name == "Cached")
        #expect(remoteCallCount == 0)
    }

    @Test
    func testLoad_WhenCacheDoesNotExist_FetchesAndSavesRemoteValue() async throws {
        let remoteValue = CharacterResponseDTO.fixture(
            results: [.fixture(id: 2, name: "Remote")]
        )

        let result = try await sut.load(key: "episode-2") {
            remoteValue
        }

        #expect(result.results.first?.id == 2)
        #expect(storeSpy.receivedSaveKeys == ["episode-2"])
        #expect(storeSpy.receivedValues.first?.results.first?.id == 2)
        #expect(storeSpy.receivedCreationDates == [dateProviderStub.now])
    }

    @Test
    func testLoad_WhenCacheIsExpired_FetchesRemoteValue() async throws {
        storeSpy.loadResult = .success(
            CacheEntry(
                value: .fixture(results: [.fixture(name: "Expired")]),
                createdAt: dateProviderStub.now.addingTimeInterval(-120)
            )
        )

        let result = try await sut.load(key: "episode-1") {
            .fixture(results: [.fixture(name: "Fresh")])
        }

        #expect(result.results.first?.name == "Fresh")
    }

    @Test
    func testLoad_WhenCacheReadFails_FetchesRemoteValue() async throws {
        storeSpy.loadResult = .failure(CacheFirstLoaderTestError.expected)

        let result = try await sut.load(key: "episode-1") {
            .fixture(results: [.fixture(name: "Remote")])
        }

        #expect(result.results.first?.name == "Remote")
    }

    @Test
    func testLoad_WhenSaveFails_ReturnsRemoteValue() async throws {
        storeSpy.saveError = CacheFirstLoaderTestError.expected

        let result = try await sut.load(key: "episode-1") {
            .fixture(results: [.fixture(name: "Remote")])
        }

        #expect(result.results.first?.name == "Remote")
    }

    @Test
    func testLoad_WhenCacheIsExpiredAndRemoteFails_PropagatesRemoteError() async {
        storeSpy.loadResult = .success(
            CacheEntry(
                value: .fixture(results: [.fixture(name: "Expired")]),
                createdAt: dateProviderStub.now.addingTimeInterval(-121)
            )
        )

        await #expect(throws: AppError.timeout) {
            try await sut.load(key: "episode-1") {
                throw AppError.timeout
            }
        }
    }
}

private enum CacheFirstLoaderTestError: Error {
    case expected
}
