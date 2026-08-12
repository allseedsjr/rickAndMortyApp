import Foundation
import Kingfisher

enum ImageCacheConfigurator {
    static func configure(ttl: TimeInterval) {
        let expiration = StorageExpiration.seconds(ttl)
        ImageCache.default.memoryStorage.config.expiration = expiration
        ImageCache.default.diskStorage.config.expiration = expiration
    }
}
