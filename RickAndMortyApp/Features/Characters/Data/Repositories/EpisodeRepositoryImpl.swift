final class EpisodeRepositoryImpl: EpisodeRepositoryProtocol {
    private let remoteDataSource: any EpisodeDataSourceProtocol
    private let cacheLoader: any CacheFirstLoading<EpisodeDTO>

    init(
        remoteDataSource: any EpisodeDataSourceProtocol,
        cacheLoader: any CacheFirstLoading<EpisodeDTO>
    ) {
        self.remoteDataSource = remoteDataSource
        self.cacheLoader = cacheLoader
    }

    func getEpisode(id: Int) async throws -> Episode {
        let dto = try await cacheLoader.load(key: String(id)) {
            try await remoteDataSource.getEpisode(id: id)
        }
        return Episode(dto: dto)
    }
}
