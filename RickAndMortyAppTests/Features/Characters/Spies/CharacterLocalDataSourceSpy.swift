import Foundation
@testable import RickAndMortyApp

final class CharacterLocalDataSourceSpy: CharacterLocalDataSourceProtocol {
    var loadResult: Result<CharacterCacheEntry?, Error> = .success(nil)
    var saveError: Error?
    private(set) var loadCallCount = 0
    private(set) var receivedResponses: [CharacterResponseDTO] = []
    private(set) var receivedCreationDates: [Date] = []

    func loadCharacters() async throws -> CharacterCacheEntry? {
        loadCallCount += 1
        return try loadResult.get()
    }

    func saveCharacters(
        _ response: CharacterResponseDTO,
        createdAt: Date
    ) async throws {
        receivedResponses.append(response)
        receivedCreationDates.append(createdAt)

        if let saveError {
            throw saveError
        }
    }
}
