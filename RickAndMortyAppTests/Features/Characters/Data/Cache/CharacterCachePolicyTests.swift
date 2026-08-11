import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("CharacterCachePolicy")
struct CharacterCachePolicyTests {
    private let currentDate = Date(timeIntervalSince1970: 1_000)

    @Test
    func testDefaultTTL_ReturnsTwoMinutes() {
        #expect(CharacterCachePolicy.default.ttl == 120)
    }

    @Test
    func testIsValid_WhenCacheAgeIsBeforeTTL_ReturnsTrue() {
        let sut = CharacterCachePolicy(ttl: 120)
        let createdAt = currentDate.addingTimeInterval(-119)

        let isValid = sut.isValid(
            createdAt: createdAt,
            currentDate: currentDate
        )

        #expect(isValid)
    }

    @Test
    func testIsValid_WhenCacheAgeIsExactlyTTL_ReturnsFalse() {
        let sut = CharacterCachePolicy(ttl: 120)
        let createdAt = currentDate.addingTimeInterval(-120)

        let isValid = sut.isValid(
            createdAt: createdAt,
            currentDate: currentDate
        )

        #expect(isValid == false)
    }

    @Test
    func testIsValid_WhenCacheAgeIsAfterTTL_ReturnsFalse() {
        let sut = CharacterCachePolicy(ttl: 120)
        let createdAt = currentDate.addingTimeInterval(-121)

        let isValid = sut.isValid(
            createdAt: createdAt,
            currentDate: currentDate
        )

        #expect(isValid == false)
    }

    @Test
    func testIsValid_UsesConfiguredTTL() {
        let sut = CharacterCachePolicy(ttl: 30)
        let createdAt = currentDate.addingTimeInterval(-31)

        let isValid = sut.isValid(
            createdAt: createdAt,
            currentDate: currentDate
        )

        #expect(isValid == false)
    }
}
