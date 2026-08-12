import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("CodableCacheStore", .serialized)
final class CodableCacheStoreTests {
    private let dataStoreSpy = DataStoreSpy()
    private lazy var sut = CodableCacheStore<CharacterResponseDTO>(dataStore: dataStoreSpy)

    @Test
    func testLoad_WhenCacheDoesNotExist_ReturnsNil() async throws {
        dataStoreSpy.readResult = .success(nil)

        let result = try await sut.load(for: "1")

        #expect(result == nil)
    }

    @Test
    func testLoad_ReturnsValueForRequestedKey() async throws {
        let cache = [
            "1": CacheEntry(value: CharacterResponseDTO.fixture(results: [.fixture(id: 1, name: "Rick")]), createdAt: .distantPast),
            "2": CacheEntry(value: CharacterResponseDTO.fixture(results: [.fixture(id: 2, name: "Morty")]), createdAt: .distantPast)
        ]
        dataStoreSpy.readResult = .success(try JSONEncoder().encode(cache))

        let result = try await sut.load(for: "2")

        #expect(result?.value.results.first?.id == 2)
        #expect(result?.value.results.first?.name == "Morty")
    }

    @Test
    func testLoad_WhenDataIsCorrupted_ThrowsDecodingError() async {
        dataStoreSpy.readResult = .success(Data("invalid-json".utf8))

        await #expect(throws: DecodingError.self) {
            try await sut.load(for: "1")
        }
    }

    @Test
    func testSave_PreservesExistingValues() async throws {
        let cache = [
            "1": CacheEntry(value: CharacterResponseDTO.fixture(results: [.fixture(id: 1, name: "Rick")]), createdAt: .distantPast)
        ]
        dataStoreSpy.readResult = .success(try JSONEncoder().encode(cache))
        let createdAt = Date(timeIntervalSince1970: 3_000)

        try await sut.save(
            .fixture(results: [.fixture(id: 2, name: "Morty")]),
            for: "2",
            createdAt: createdAt
        )

        let data = try #require(dataStoreSpy.receivedData)
        let writtenCache = try JSONDecoder().decode(
            [String: CacheEntry<CharacterResponseDTO>].self,
            from: data
        )
        #expect(writtenCache["1"]?.value.results.first?.name == "Rick")
        #expect(writtenCache["2"]?.value.results.first?.name == "Morty")
        #expect(writtenCache["2"]?.createdAt == createdAt)
    }

    @Test
    func testSave_WhenExistingCacheIsCorrupted_ReplacesCache() async throws {
        dataStoreSpy.readResult = .success(Data("invalid-json".utf8))

        try await sut.save(
            .fixture(results: [.fixture(id: 3)]),
            for: "3",
            createdAt: .distantPast
        )

        let data = try #require(dataStoreSpy.receivedData)
        let writtenCache = try JSONDecoder().decode(
            [String: CacheEntry<CharacterResponseDTO>].self,
            from: data
        )
        #expect(writtenCache.count == 1)
        #expect(writtenCache["3"]?.value.results.first?.id == 3)
    }

    @Test
    func testSave_WhenWritesAreConcurrent_PreservesEveryValue() async throws {
        let directoryURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directoryURL) }
        let fileStore = FileDataStore(
            fileURL: directoryURL.appendingPathComponent("episodes.json")
        )
        let sut = CodableCacheStore<CharacterResponseDTO>(dataStore: fileStore)

        async let firstSave: Void = sut.save(
            .fixture(results: [.fixture(id: 1, name: "Rick")]),
            for: "1",
            createdAt: .distantPast
        )
        async let secondSave: Void = sut.save(
            .fixture(results: [.fixture(id: 2, name: "Morty")]),
            for: "2",
            createdAt: .distantPast
        )

        _ = try await (firstSave, secondSave)

        #expect(try await sut.load(for: "1")?.value.results.first?.id == 1)
        #expect(try await sut.load(for: "2")?.value.results.first?.id == 2)
    }
}
