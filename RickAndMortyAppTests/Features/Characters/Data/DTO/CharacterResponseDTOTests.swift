import Foundation
import Testing
@testable import RickAndMortyApp

@Suite("CharacterResponseDTO")
struct CharacterResponseDTOTests {
    @Test
    func testDecode_WhenJSONIsValid_ReturnsCharacterResponseDTO() throws {
        let response = try JSONDecoder().decode(
            CharacterResponseDTO.self,
            from: CharacterResponseDTO.validJSONFixture
        )

        #expect(response.info.count == 826)
        #expect(response.info.pages == 42)
        #expect(response.info.next == "https://rickandmortyapi.com/api/character?page=2")
        #expect(response.info.prev == nil)

        let character = try #require(response.results.first)
        #expect(character.id == 1)
        #expect(character.name == "Rick Sanchez")
        #expect(character.status == "Alive")
        #expect(character.species == "Human")
        #expect(character.type.isEmpty)
        #expect(character.gender == "Male")
        #expect(character.origin.name == "Earth (C-137)")
        #expect(character.location.name == "Citadel of Ricks")
        #expect(character.image == "https://example.com/rick.jpeg")
        #expect(character.episode == ["https://rickandmortyapi.com/api/episode/1"])
        #expect(character.url == "https://rickandmortyapi.com/api/character/1")
        #expect(character.created == "2017-11-04T18:48:46.250Z")
    }
}
