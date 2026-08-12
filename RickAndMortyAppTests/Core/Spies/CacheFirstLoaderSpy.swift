@testable import RickAndMortyApp

final class CacheFirstLoaderSpy<Value: Codable>: CacheFirstLoading {
    private(set) var receivedKeys: [String] = []
    private(set) var remoteCallCount = 0
    var result: Result<Value, Error>?

    func load(
        key: String,
        remote: () async throws -> Value
    ) async throws -> Value {
        receivedKeys.append(key)

        if let result {
            return try result.get()
        }

        remoteCallCount += 1
        return try await remote()
    }
}
