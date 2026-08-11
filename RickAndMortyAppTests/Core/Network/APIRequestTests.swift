import Testing
@testable import RickAndMortyApp

@Suite("APIRequest")
struct APIRequestTests {
    private let sut = DefaultAPIRequestStub()

    @Test
    func testMethod_WhenNotProvided_ReturnsGET() {
        #expect(sut.method == .get)
    }

    @Test
    func testHeaders_WhenNotProvided_ReturnsEmptyDictionary() {
        #expect(sut.headers.isEmpty)
    }

    @Test
    func testQueryItems_WhenNotProvided_ReturnsEmptyArray() {
        #expect(sut.queryItems.isEmpty)
    }
}
