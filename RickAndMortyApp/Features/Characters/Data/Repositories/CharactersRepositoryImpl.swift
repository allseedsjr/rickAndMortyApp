final class CharactersRepositoryImpl: CharacterRepositoryProtocol {
    private enum CacheKey {
        static let firstPage = "characters-page-1"
    }

    private let remoteDataSource: CharacterDataSourceProtocol
    private let cacheLoader: any CacheFirstLoading<CharacterResponseDTO>
    private let errorMapper: any AppErrorMapping

    init(
        remoteDataSource: CharacterDataSourceProtocol,
        cacheLoader: any CacheFirstLoading<CharacterResponseDTO>,
        errorMapper: any AppErrorMapping
    ) {
        self.remoteDataSource = remoteDataSource
        self.cacheLoader = cacheLoader
        self.errorMapper = errorMapper
    }

    func getCharacters(page: Int) async throws -> CharactersPage {
        do {
            guard page == 1 else {
                let response = try await remoteDataSource.getCharacters(page: page)
                return CharactersPage(dto: response)
            }

            let response = try await cacheLoader.load(key: CacheKey.firstPage) {
                try await remoteDataSource.getCharacters(page: page)
            }
            return CharactersPage(dto: response)
        } catch {
            throw errorMapper.map(error)
        }
    }
}
