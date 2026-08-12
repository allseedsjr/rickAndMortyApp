import Foundation

struct CachePolicy {
    let ttl: TimeInterval

    static let `default` = CachePolicy(ttl: 2 * 60)

    func isValid(
        createdAt: Date,
        currentDate: Date
    ) -> Bool {
        let age = currentDate.timeIntervalSince(createdAt)
        return age >= 0 && age < ttl
    }
}
