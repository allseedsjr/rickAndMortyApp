import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("GetCharactersRequest")
struct GetCharactersRequestTests {
    private let sut = GetCharactersRequest(page: 2)

    @Test
    func testPath_ReturnsCharactersPath() {
        #expect(sut.path == APIEndpoint.Path.characters.rawValue)
    }

    @Test
    func testMethod_ReturnsGET() {
        #expect(sut.method == .get)
    }

    @Test
    func testQueryItems_IncludesRequestedPage() {
        #expect(sut.queryItems.count == 1)
        #expect(sut.queryItems.first?.name == "page")
        #expect(sut.queryItems.first?.value == "2")
    }
}
