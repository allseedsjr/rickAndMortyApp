import Foundation

struct Character: Equatable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: CharacterSpecies
    let type: String
    let gender: CharacterGender
    let imageURL: String
    let originName: String
    let locationName: String
    let episodeCount: Int
    let firstEpisodeID: Int?

    init(
        id: Int,
        name: String,
        status: CharacterStatus,
        species: CharacterSpecies,
        type: String,
        gender: CharacterGender,
        imageURL: String,
        originName: String,
        locationName: String,
        episodeCount: Int,
        firstEpisodeID: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.imageURL = imageURL
        self.originName = originName
        self.locationName = locationName
        self.episodeCount = episodeCount
        self.firstEpisodeID = firstEpisodeID
    }
}
