import Foundation

struct CharacterCachePolicy {
    let ttl: TimeInterval

    static let `default` = CharacterCachePolicy(
        ttl: 2 * 60
    )

    func isValid(
        createdAt: Date,
        currentDate: Date
    ) -> Bool {
        currentDate.timeIntervalSince(createdAt) < ttl
    }
}
