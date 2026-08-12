protocol HomeInteracting {
    func getCharacters(page: Int) async throws -> CharactersPage
}

final class HomeInteractor: HomeInteracting {
    private let getCharactersUseCase: GetCharactersUseCasing

    init(getCharactersUseCase: GetCharactersUseCasing) {
        self.getCharactersUseCase = getCharactersUseCase
    }

    func getCharacters(page: Int) async throws -> CharactersPage {
        try await getCharactersUseCase.execute(page: page)
    }
}
