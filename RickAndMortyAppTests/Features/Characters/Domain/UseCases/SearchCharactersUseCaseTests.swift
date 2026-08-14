import Testing
@testable import RickAndMortyApp

@Suite("SearchCharactersUseCase")
struct SearchCharactersUseCaseTests {
    private let sut = SearchCharactersUseCase()

    @Test
    func testExecute_WhenQueryMatchesName_ReturnsMatchingCharacters() {
        let characters = [
            Character.fixture(name: "Rick Sanchez"),
            Character.fixture(name: "Morty Smith")
        ]

        let result = sut.execute(characters: characters, query: "rick")

        #expect(result.count == 1)
        #expect(result.first?.name == "Rick Sanchez")
    }

    @Test
    func testExecute_WhenQueryHasDifferentCase_ReturnsMatchingCharacters() {
        let characters = [Character.fixture(name: "Summer Smith")]

        let result = sut.execute(characters: characters, query: "SUMMER")

        #expect(result.count == 1)
    }

    @Test
    func testExecute_WhenQueryContainsSurroundingWhitespace_IgnoresWhitespace() {
        let characters = [Character.fixture(name: "Beth Smith")]

        let result = sut.execute(characters: characters, query: "  Beth  ")

        #expect(result.count == 1)
    }

    @Test
    func testExecute_WhenQueryIsEmpty_ReturnsAllCharacters() {
        let characters = [
            Character.fixture(name: "Rick Sanchez"),
            Character.fixture(name: "Morty Smith")
        ]

        let result = sut.execute(characters: characters, query: "   ")

        #expect(result.count == 2)
    }

    @Test
    func testExecute_WhenQueryDoesNotMatch_ReturnsEmptyList() {
        let characters = [Character.fixture(name: "Jerry Smith")]

        let result = sut.execute(characters: characters, query: "Birdperson")

        #expect(result.isEmpty)
    }

    @Test
    func testExecute_WhenCharactersAreEmpty_ReturnsEmptyList() {
        let result = sut.execute(characters: [], query: "Rick")

        #expect(result.isEmpty)
    }

    @Test
    func testExecute_WhenQueryMatchesPartOfName_ReturnsMatchingCharacters() {
        let characters = [
            Character.fixture(name: "Evil Morty"),
            Character.fixture(name: "Jerry Smith")
        ]

        let result = sut.execute(characters: characters, query: "Mort")

        #expect(result.count == 1)
        #expect(result.first?.name == "Evil Morty")
    }
}
