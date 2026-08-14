final class EpisodeRepositoryImpl: EpisodeRepositoryProtocol {
    private let remoteDataSource: any EpisodeDataSourceProtocol
    private let cacheLoader: any CacheFirstLoading<EpisodeDTO>
    private let errorMapper: any AppErrorMapping

    init(
        remoteDataSource: any EpisodeDataSourceProtocol,
        cacheLoader: any CacheFirstLoading<EpisodeDTO>,
        errorMapper: any AppErrorMapping
    ) {
        self.remoteDataSource = remoteDataSource
        self.cacheLoader = cacheLoader
        self.errorMapper = errorMapper
    }

    func getEpisode(id: Int) async throws -> Episode {
        do {
            let dto = try await cacheLoader.load(key: String(id)) {
                try await remoteDataSource.getEpisode(id: id)
            }
            return Episode(dto: dto)
        } catch {
            throw errorMapper.map(error)
        }
    }
}
