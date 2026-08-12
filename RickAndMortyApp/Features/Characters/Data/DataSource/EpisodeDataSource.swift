protocol EpisodeDataSourceProtocol {
    func getEpisode(id: Int) async throws -> EpisodeDTO
}

final class EpisodeDataSource: EpisodeDataSourceProtocol {
    private let apiClient: any APIClient

    init(apiClient: any APIClient) {
        self.apiClient = apiClient
    }

    func getEpisode(id: Int) async throws -> EpisodeDTO {
        try await apiClient.execute(
            GetEpisodeRequest(episodeID: id)
        )
    }
}
