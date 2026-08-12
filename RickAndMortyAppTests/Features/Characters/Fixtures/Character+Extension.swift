@testable import RickAndMortyApp

extension Character {
    static func fixture(
        id: Int = 1,
        name: String = "Rick Sanchez",
        status: String = "Alive",
        species: String = "Human",
        type: String = "",
        gender: String = "Male",
        imageURL: String = "https://example.com/rick.jpeg",
        originName: String = "Earth (C-137)",
        locationName: String = "Citadel of Ricks",
        episodeCount: Int = 1,
        firstEpisodeID: Int? = 1
    ) -> Character {
        Character(
            id: id,
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            imageURL: imageURL,
            originName: originName,
            locationName: locationName,
            episodeCount: episodeCount,
            firstEpisodeID: firstEpisodeID
        )
    }
}
