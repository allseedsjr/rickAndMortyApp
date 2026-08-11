import Foundation
@testable import RickAndMortyApp

final class DateProviderStub: DateProviding {
    var now: Date

    init(now: Date) {
        self.now = now
    }
}
