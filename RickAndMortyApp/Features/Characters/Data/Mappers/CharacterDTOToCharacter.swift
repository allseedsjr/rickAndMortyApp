import Foundation

extension Character {
    init(dto: CharacterDTO) {
        self.init(
            id: dto.id,
            name: dto.name,
            status: dto.status,
            species: dto.species,
            type: dto.type,
            gender: dto.gender,
            imageURL: dto.image,
            originName: dto.origin.name,
            locationName: dto.location.name,
            episodeCount: dto.episode.count,
            firstEpisodeID: dto.episode.first.flatMap(Self.episodeID)
        )
    }

    private static func episodeID(from value: String) -> Int? {
        guard let url = URL(string: value),
              let id = Int(url.lastPathComponent) else {
            return nil
        }

        return id
    }
}
