extension Episode {
    init(dto: EpisodeDTO) {
        self.init(
            id: dto.id,
            name: dto.name,
            code: dto.episode,
            airDate: dto.airDate
        )
    }
}
