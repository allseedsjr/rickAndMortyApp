protocol GetCharactersUseCasing {
    func execute(page: Int) async throws -> CharactersPage
}

final class GetCharactersUseCase: GetCharactersUseCasing {
    private let repository: CharacterRepositoryProtocol
    
    init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> CharactersPage {
        try await repository.getCharacters(page: page)
    }
}
