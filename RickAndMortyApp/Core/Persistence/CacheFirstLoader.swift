protocol CacheFirstLoading<Value> {
    associatedtype Value: Codable

    func load(
        key: String,
        remote: () async throws -> Value
    ) async throws -> Value
}

final class CacheFirstLoader<Value: Codable>: CacheFirstLoading {
    private let store: any CacheStoring<Value>
    private let policy: CachePolicy
    private let dateProvider: any DateProviding

    init(
        store: any CacheStoring<Value>,
        policy: CachePolicy,
        dateProvider: any DateProviding = SystemDateProvider()
    ) {
        self.store = store
        self.policy = policy
        self.dateProvider = dateProvider
    }

    func load(
        key: String,
        remote: () async throws -> Value
    ) async throws -> Value {
        if let entry = try? await store.load(for: key),
           policy.isValid(
               createdAt: entry.createdAt,
               currentDate: dateProvider.now
           ) {
            return entry.value
        }

        let value = try await remote()
        try? await store.save(
            value,
            for: key,
            createdAt: dateProvider.now
        )
        return value
    }
}
