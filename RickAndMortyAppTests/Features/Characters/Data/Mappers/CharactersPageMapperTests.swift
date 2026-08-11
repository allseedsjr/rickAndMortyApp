import Testing
@testable import RickAndMortyApp

@Suite("CharactersPage Mapper")
struct CharactersPageMapperTests {
    @Test
    func testInit_WhenDTOIsProvided_MapsAllCharactersPreservingOrder() {
        let firstDTO = CharacterDTO.fixture(id: 1, name: "Rick Sanchez")
        let secondDTO = CharacterDTO.fixture(id: 2, name: "Morty Smith")
        let dto = CharacterResponseDTO.fixture(results: [firstDTO, secondDTO])

        let page = CharactersPage(dto: dto)

        #expect(page.characters.map(\.id) == [1, 2])
        #expect(page.characters.map(\.name) == ["Rick Sanchez", "Morty Smith"])
    }

    @Test
    func testInit_WhenNextPageExists_SetsHasNextPageToTrue() {
        let dto = CharacterResponseDTO.fixture(
            info: .fixture(next: "https://rickandmortyapi.com/api/character?page=2")
        )

        let page = CharactersPage(dto: dto)

        #expect(page.hasNextPage)
    }

    @Test
    func testInit_WhenNextPageDoesNotExist_SetsHasNextPageToFalse() {
        let dto = CharacterResponseDTO.fixture(
            info: .fixture(next: nil)
        )

        let page = CharactersPage(dto: dto)

        #expect(page.hasNextPage == false)
    }
}
