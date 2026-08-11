import Testing
@testable import RickAndMortyApp

@Suite("Character Mapper")
struct CharacterMapperTests {
    @Test
    func testInit_WhenDTOIsProvided_MapsAllFields() {
        let dto = CharacterDTO.fixture(
            id: 7,
            name: "Squanchy",
            status: "Alive",
            species: "Alien",
            type: "Cat-Person",
            gender: "Male",
            origin: .fixture(name: "Planet Squanch"),
            location: .fixture(name: "Replacement Dimension"),
            image: "https://example.com/squanchy.jpeg",
            episode: ["episode-1", "episode-2"]
        )
        let expectedCharacter = Character.fixture(
            id: 7,
            name: "Squanchy",
            status: "Alive",
            species: "Alien",
            type: "Cat-Person",
            gender: "Male",
            imageURL: "https://example.com/squanchy.jpeg",
            originName: "Planet Squanch",
            locationName: "Replacement Dimension",
            episodeCount: 2,
            firstEpisodeURL: "episode-1"
        )

        let character = Character(dto: dto)

        #expect(character == expectedCharacter)
    }

    @Test
    func testInit_WhenEpisodesAreEmpty_MapsEmptyEpisodeInformation() {
        let dto = CharacterDTO.fixture(episode: [])

        let character = Character(dto: dto)

        #expect(character.episodeCount == 0)
        #expect(character.firstEpisodeURL == nil)
    }
}
