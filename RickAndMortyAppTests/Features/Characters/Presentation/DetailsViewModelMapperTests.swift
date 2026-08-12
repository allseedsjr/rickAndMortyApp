import Testing
@testable import RickAndMortyApp

@Suite("DetailsViewModelMapper")
struct DetailsViewModelMapperTests {
    private let sut = DetailsViewModelMapper()

    @Test
    func testMapCharacter_MapsDetailsContent() {
        let character = Character.fixture(
            name: "Morty Smith",
            status: "Alive",
            species: "Human",
            gender: "Male",
            originName: "unknown",
            locationName: "Citadel of Ricks",
            episodeCount: 51
        )

        let result = sut.map(character)

        #expect(result.name == "Morty Smith")
        #expect(result.status == "Alive")
        #expect(result.species == "Human")
        #expect(result.gender == "Male")
        #expect(result.origin == "unknown")
        #expect(result.location == "Citadel of Ricks")
        #expect(result.episodeCount == "51")
        #expect(result.imageURL != nil)
    }

    @Test
    func testMapFirstSeenIn_ComposesEpisodeDescription() {
        let firstSeenIn = FirstSeenIn.fixture(
            episodeName: "Pilot",
            episodeCode: "S01E01",
            airDate: "December 2, 2013"
        )

        let result = sut.map(firstSeenIn)

        #expect(result.episode == "Pilot (S01E01)")
        #expect(result.airDate == "December 2, 2013")
    }
}
