protocol CharacterDataSourceProtocol {
    func getCharacters(
        page: Int
    ) async throws -> CharacterResponseDTO
}

final class CharacterDataSource: CharacterDataSourceProtocol {
    private let apiClient: any APIClient
    
    init(
        apiClient: any APIClient
    ) {
        self.apiClient = apiClient
    }
    
    func getCharacters(
        page: Int
    ) async throws -> CharacterResponseDTO {
        try await apiClient.execute(
            GetCharactersRequest(page: page)
        )
    }
}
