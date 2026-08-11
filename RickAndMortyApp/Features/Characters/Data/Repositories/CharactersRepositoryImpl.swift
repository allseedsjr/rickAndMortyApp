final class CharactersRepositoryImpl: CharacterRepositoryProtocol {
    private let remoteDataSource: CharacterDataSourceProtocol
    private let localDataSource: CharacterLocalDataSourceProtocol
    private let cachePolicy: CharacterCachePolicy
    private let dateProvider: DateProviding

    init(remoteDataSource: CharacterDataSourceProtocol,
         localDataSource: CharacterLocalDataSourceProtocol,
         cachePolicy: CharacterCachePolicy,
         dateProvider: DateProviding = SystemDateProvider()
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.cachePolicy = cachePolicy
        self.dateProvider = dateProvider
    }

    func getCharacters(page: Int) async throws -> CharactersPage {
        if page == 1, let cachedResponse = await loadValidCacheIgnoringFailure() {
            return CharactersPage(dto: cachedResponse)
        }

        let response = try await remoteDataSource.getCharacters(
            page: page
        )

        if page == 1 {
            try? await localDataSource.saveCharacters(
                response,
                createdAt: dateProvider.now
            )
        }

        return CharactersPage(dto: response)
    }

    private func loadValidCacheIgnoringFailure() async -> CharacterResponseDTO? {
        guard let entry = try? await localDataSource.loadCharacters(),
              cachePolicy.isValid(
                  createdAt: entry.createdAt,
                  currentDate: dateProvider.now
              ) else {
            return nil
        }

        return entry.response
    }
}
