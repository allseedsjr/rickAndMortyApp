final class CharactersRepositoryImpl: CharacterRepositoryProtocol {
    private let dataSource: CharacterDataSourceProtocol
    
    init(dataSource: CharacterDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func getCharacters(page: Int) async throws -> CharactersPage {
        let characterResponseDTO = try await dataSource.getCharacters(page: page)
        return CharactersPage(dto: characterResponseDTO)
    }
}
