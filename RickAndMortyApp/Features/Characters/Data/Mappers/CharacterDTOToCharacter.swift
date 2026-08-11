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
            firstEpisodeURL: dto.episode.first
        )
    }
}
