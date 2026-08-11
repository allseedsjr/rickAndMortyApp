import Foundation
@testable import RickAndMortyApp

extension CharacterCacheEntry {
    static func fixture(
        response: CharacterResponseDTO = .fixture(),
        createdAt: Date = Date(timeIntervalSince1970: 1_000)
    ) -> CharacterCacheEntry {
        CharacterCacheEntry(
            response: response,
            createdAt: createdAt
        )
    }
}
