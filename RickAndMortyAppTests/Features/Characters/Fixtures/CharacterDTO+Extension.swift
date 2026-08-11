@testable import RickAndMortyApp

extension CharacterDTO {
    static func fixture(
        id: Int = 1,
        name: String = "Rick Sanchez",
        status: String = "Alive",
        species: String = "Human",
        type: String = "",
        gender: String = "Male",
        origin: OriginDTO = .fixture(),
        location: LocationDTO = .fixture(),
        image: String = "https://example.com/rick.jpeg",
        episode: [String] = ["https://rickandmortyapi.com/api/episode/1"],
        url: String = "https://rickandmortyapi.com/api/character/1",
        created: String = "2017-11-04T18:48:46.250Z"
    ) -> CharacterDTO {
        CharacterDTO(
            id: id,
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            origin: origin,
            location: location,
            image: image,
            episode: episode,
            url: url,
            created: created
        )
    }
}
