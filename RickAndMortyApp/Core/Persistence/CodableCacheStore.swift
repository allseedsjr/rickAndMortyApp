import Foundation

actor CodableCacheStore<Value: Codable>: CacheStoring {
    private typealias Cache = [String: CacheEntry<Value>]

    private let dataStore: any DataStore
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        dataStore: any DataStore,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.dataStore = dataStore
        self.encoder = encoder
        self.decoder = decoder
    }

    func load(for key: String) async throws -> CacheEntry<Value>? {
        try loadCache()[key]
    }

    func save(
        _ value: Value,
        for key: String,
        createdAt: Date
    ) async throws {
        var cache = (try? loadCache()) ?? [:]
        cache[key] = CacheEntry(value: value, createdAt: createdAt)
        try dataStore.write(encoder.encode(cache))
    }

    private func loadCache() throws -> Cache {
        guard let data = try dataStore.read() else {
            return [:]
        }

        return try decoder.decode(Cache.self, from: data)
    }
}
