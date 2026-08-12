final class EpisodeRepositoryImpl: EpisodeRepositoryProtocol {
    private let dataSource: any EpisodeDataSourceProtocol

    init(dataSource: any EpisodeDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func getEpisode(id: Int) async throws -> Episode {
        let dto = try await dataSource.getEpisode(id: id)
        return Episode(dto: dto)
    }
}
