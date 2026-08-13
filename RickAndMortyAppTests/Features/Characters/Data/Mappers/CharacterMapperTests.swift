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
            episode: [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
            ]
        )
        let expectedCharacter = Character.fixture(
            id: 7,
            name: "Squanchy",
            status: .alive,
            species: .alien,
            type: "Cat-Person",
            gender: .male,
            imageURL: "https://example.com/squanchy.jpeg",
            originName: "Planet Squanch",
            locationName: "Replacement Dimension",
            episodeCount: 2,
            firstEpisodeID: 1
        )

        let character = Character(dto: dto)

        #expect(character == expectedCharacter)
    }

    @Test
    func testInit_WhenEpisodesAreEmpty_MapsEmptyEpisodeInformation() {
        let dto = CharacterDTO.fixture(episode: [])

        let character = Character(dto: dto)

        #expect(character.episodeCount == 0)
        #expect(character.firstEpisodeID == nil)
    }

    @Test
    func testInit_WhenFirstEpisodeURLIsInvalid_MapsNilEpisodeID() {
        let dto = CharacterDTO.fixture(episode: ["invalid-episode"])

        let character = Character(dto: dto)

        #expect(character.firstEpisodeID == nil)
    }

    @Test
    func testInit_NormalizesStatusAndGenderFromRemoteValues() {
        let dto = CharacterDTO.fixture(
            status: "  DeAd  ",
            gender: " FEMALE "
        )

        let character = Character(dto: dto)

        #expect(character.status == .dead)
        #expect(character.gender == .female)
    }

    @Test
    func testInit_WhenStatusAndGenderAreUnsupported_MapsUnknownValues() {
        let dto = CharacterDTO.fixture(
            status: "inactive",
            gender: "non-binary"
        )

        let character = Character(dto: dto)

        #expect(character.status == .unknown)
        #expect(character.gender == .unknown)
    }

    @Test
    func testInit_WhenSpeciesIsKnown_MapsTypedSpecies() {
        let dto = CharacterDTO.fixture(species: " Mythological Creature ")

        let character = Character(dto: dto)

        #expect(character.species == .mythologicalCreature)
    }

    @Test
    func testInit_WhenSpeciesIsUnsupported_PreservesRemoteValue() {
        let dto = CharacterDTO.fixture(species: "  Vampire  ")

        let character = Character(dto: dto)

        #expect(character.species == .other("Vampire"))
    }

    @Test
    func testInit_WhenSpeciesIsEmpty_MapsUnknown() {
        let dto = CharacterDTO.fixture(species: "   ")

        let character = Character(dto: dto)

        #expect(character.species == .unknown)
    }
}
