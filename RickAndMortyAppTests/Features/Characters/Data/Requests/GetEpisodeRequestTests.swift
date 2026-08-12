import Testing
@testable import RickAndMortyApp

@Suite("GetEpisodeRequest")
struct GetEpisodeRequestTests {
    @Test
    func testPath_IncludesEpisodeID() {
        let sut = GetEpisodeRequest(episodeID: 28)

        #expect(sut.path == "/api/episode/28")
    }

    @Test
    func testMethod_ReturnsGET() {
        let sut = GetEpisodeRequest(episodeID: 1)

        #expect(sut.method == .get)
    }
}
