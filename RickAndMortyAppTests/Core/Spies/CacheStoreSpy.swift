import Foundation
@testable import RickAndMortyApp

final class CacheStoreSpy<Value: Codable>: CacheStoring {
    var loadResult: Result<CacheEntry<Value>?, Error> = .success(nil)
    var saveError: Error?
    private(set) var receivedLoadKeys: [String] = []
    private(set) var receivedValues: [Value] = []
    private(set) var receivedSaveKeys: [String] = []
    private(set) var receivedCreationDates: [Date] = []

    func load(for key: String) async throws -> CacheEntry<Value>? {
        receivedLoadKeys.append(key)
        return try loadResult.get()
    }

    func save(
        _ value: Value,
        for key: String,
        createdAt: Date
    ) async throws {
        receivedValues.append(value)
        receivedSaveKeys.append(key)
        receivedCreationDates.append(createdAt)

        if let saveError {
            throw saveError
        }
    }
}
