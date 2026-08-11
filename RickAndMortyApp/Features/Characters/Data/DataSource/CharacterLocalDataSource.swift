import Foundation

protocol CharacterLocalDataSourceProtocol {
    func loadCharacters() async throws -> CharacterCacheEntry?

    func saveCharacters(
        _ response: CharacterResponseDTO,
        createdAt: Date
    ) async throws
}

actor CharacterLocalDataSource: CharacterLocalDataSourceProtocol {
    private let dataStore: DataStore
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        dataStore: DataStore,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.dataStore = dataStore
        self.encoder = encoder
        self.decoder = decoder
    }

    func loadCharacters() async throws -> CharacterCacheEntry? {
        guard let data = try dataStore.read() else {
            return nil
        }

        return try decoder.decode(
            CharacterCacheEntry.self,
            from: data
        )
    }

    func saveCharacters(
        _ response: CharacterResponseDTO,
        createdAt: Date
    ) async throws {
        let entry = CharacterCacheEntry(
            response: response,
            createdAt: createdAt
        )

        let data = try encoder.encode(entry)

        try dataStore.write(data)
    }
}
