import Testing
@testable import RickAndMortyApp

@Suite("CharacterSearchFilter")
struct CharacterSearchFilterTests {
    private let sut = CharacterSearchFilter()

    @Test
    func testFilter_WhenQueryMatchesName_ReturnsMatchingCharacters() {
        let characters = [
            Character.fixture(name: "Rick Sanchez"),
            Character.fixture(name: "Morty Smith")
        ]

        let result = sut.filter(characters, by: "rick")

        #expect(result.count == 1)
        #expect(result.first?.name == "Rick Sanchez")
    }

    @Test
    func testFilter_WhenQueryHasDifferentCase_ReturnsMatchingCharacters() {
        let characters = [Character.fixture(name: "Summer Smith")]

        let result = sut.filter(characters, by: "SUMMER")

        #expect(result.count == 1)
    }

    @Test
    func testFilter_WhenQueryContainsSurroundingWhitespace_IgnoresWhitespace() {
        let characters = [Character.fixture(name: "Beth Smith")]

        let result = sut.filter(characters, by: "  Beth  ")

        #expect(result.count == 1)
    }

    @Test
    func testFilter_WhenQueryIsEmpty_ReturnsAllCharacters() {
        let characters = [
            Character.fixture(name: "Rick Sanchez"),
            Character.fixture(name: "Morty Smith")
        ]

        let result = sut.filter(characters, by: "   ")

        #expect(result.count == 2)
    }

    @Test
    func testFilter_WhenQueryDoesNotMatch_ReturnsEmptyList() {
        let characters = [Character.fixture(name: "Jerry Smith")]

        let result = sut.filter(characters, by: "Birdperson")

        #expect(result.isEmpty)
    }

    @Test
    func testFilter_WhenCharactersAreEmpty_ReturnsEmptyList() {
        let result = sut.filter([], by: "Rick")

        #expect(result.isEmpty)
    }

    @Test
    func testFilter_WhenQueryMatchesPartOfName_ReturnsMatchingCharacters() {
        let characters = [
            Character.fixture(name: "Evil Morty"),
            Character.fixture(name: "Jerry Smith")
        ]

        let result = sut.filter(characters, by: "Mort")

        #expect(result.count == 1)
        #expect(result.first?.name == "Evil Morty")
    }
}
