import Foundation

protocol CacheStoring<Value> {
    associatedtype Value: Codable

    func load(for key: String) async throws -> CacheEntry<Value>?
    func save(
        _ value: Value,
        for key: String,
        createdAt: Date
    ) async throws
}
