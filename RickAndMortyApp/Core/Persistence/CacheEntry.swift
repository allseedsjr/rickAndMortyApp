import Foundation

struct CacheEntry<Value: Codable>: Codable {
    let value: Value
    let createdAt: Date
}
