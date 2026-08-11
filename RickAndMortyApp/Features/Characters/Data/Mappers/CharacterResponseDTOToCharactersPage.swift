extension CharactersPage {
    init(dto: CharacterResponseDTO) {
        self.init(
            characters: dto.results.map {
                Character(dto: $0)
            },
            hasNextPage: dto.info.next != nil
        )
    }
}
