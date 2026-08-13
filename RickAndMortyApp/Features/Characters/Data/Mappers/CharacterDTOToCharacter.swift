import Foundation

extension Character {
    init(dto: CharacterDTO) {
        self.init(
            id: dto.id,
            name: dto.name,
            status: CharacterAttributeMapper.status(from: dto.status),
            species: CharacterAttributeMapper.species(from: dto.species),
            type: dto.type,
            gender: CharacterAttributeMapper.gender(from: dto.gender),
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
