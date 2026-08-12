import Testing
@testable import RickAndMortyApp

@Suite("Episode Mapper")
struct EpisodeMapperTests {
    @Test
    func testInit_WhenEpisodeDTOIsProvided_MapsEpisodeInformation() {
        let dto = EpisodeDTO.fixture(
            name: "Meeseeks and Destroy",
            episode: "S01E05",
            airDate: "January 13, 2014"
        )

        let result = Episode(dto: dto)

        #expect(result.id == dto.id)
        #expect(result.name == "Meeseeks and Destroy")
        #expect(result.code == "S01E05")
        #expect(result.airDate == "January 13, 2014")
    }
}
