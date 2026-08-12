import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("CachePolicy")
struct CachePolicyTests {
    @Test
    func testDefaultTTL_ReturnsTwoMinutes() {
        #expect(CachePolicy.default.ttl == 120)
    }

    @Test
    func testIsValid_WhenAgeIsBeforeTTL_ReturnsTrue() {
        let sut = CachePolicy(ttl: 120)
        let now = Date(timeIntervalSince1970: 1_000)

        #expect(sut.isValid(createdAt: now.addingTimeInterval(-119), currentDate: now))
    }

    @Test
    func testIsValid_WhenAgeReachesTTL_ReturnsFalse() {
        let sut = CachePolicy(ttl: 120)
        let now = Date(timeIntervalSince1970: 1_000)

        #expect(!sut.isValid(createdAt: now.addingTimeInterval(-120), currentDate: now))
    }

    @Test
    func testIsValid_WhenCreationDateIsInTheFuture_ReturnsFalse() {
        let sut = CachePolicy(ttl: 120)
        let now = Date(timeIntervalSince1970: 1_000)

        #expect(!sut.isValid(createdAt: now.addingTimeInterval(1), currentDate: now))
    }
}
