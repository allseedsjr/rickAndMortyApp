import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("CharacterLocalDataSource", .serialized)
final class CharacterLocalDataSourceTests {
    private let dataStoreSpy = DataStoreSpy()
    private lazy var sut = CharacterLocalDataSource(
        dataStore: dataStoreSpy
    )

    @Test
    func testLoadCharacters_WhenDataDoesNotExist_ReturnsNil() async throws {
        dataStoreSpy.readResult = .success(nil)

        let entry = try await sut.loadCharacters()

        #expect(entry == nil)
    }

    @Test
    func testLoadCharacters_WhenDataIsValid_ReturnsDecodedEntry() async throws {
        let expectedEntry = CharacterCacheEntry.fixture(
            response: .fixture(
                results: [.fixture(id: 7, name: "Squanchy")]
            ),
            createdAt: Date(timeIntervalSince1970: 2_000)
        )
        dataStoreSpy.readResult = .success(
            try JSONEncoder().encode(expectedEntry)
        )

        let loadedEntry = try await sut.loadCharacters()
        let entry = try #require(loadedEntry)

        #expect(entry.createdAt == expectedEntry.createdAt)
        #expect(entry.response.results.first?.id == 7)
        #expect(entry.response.results.first?.name == "Squanchy")
    }

    @Test
    func testLoadCharacters_WhenDataStoreFails_PropagatesError() async {
        dataStoreSpy.readResult = .failure(
            CharacterLocalDataSourceTestError.expected
        )

        await #expect(throws: CharacterLocalDataSourceTestError.expected) {
            try await sut.loadCharacters()
        }
    }

    @Test
    func testLoadCharacters_WhenDataIsInvalid_ThrowsDecodingError() async {
        dataStoreSpy.readResult = .success(Data("invalid-json".utf8))

        await #expect(throws: DecodingError.self) {
            try await sut.loadCharacters()
        }
    }

    @Test
    func testSaveCharacters_EncodesAndWritesCacheEntry() async throws {
        let response = CharacterResponseDTO.fixture(
            results: [.fixture(id: 7, name: "Squanchy")]
        )
        let createdAt = Date(timeIntervalSince1970: 2_000)

        try await sut.saveCharacters(
            response,
            createdAt: createdAt
        )

        let data = try #require(dataStoreSpy.receivedData)
        let entry = try JSONDecoder().decode(
            CharacterCacheEntry.self,
            from: data
        )
        #expect(entry.createdAt == createdAt)
        #expect(entry.response.results.first?.id == 7)
        #expect(entry.response.results.first?.name == "Squanchy")
    }

    @Test
    func testSaveCharacters_WhenDataStoreFails_PropagatesError() async {
        dataStoreSpy.writeError = CharacterLocalDataSourceTestError.expected

        await #expect(throws: CharacterLocalDataSourceTestError.expected) {
            try await sut.saveCharacters(
                .fixture(),
                createdAt: Date(timeIntervalSince1970: 2_000)
            )
        }
    }
}

private enum CharacterLocalDataSourceTestError: Error {
    case expected
}
