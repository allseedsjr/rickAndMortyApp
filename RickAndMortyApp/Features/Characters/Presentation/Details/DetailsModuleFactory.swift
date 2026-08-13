import Alamofire
import UIKit

@MainActor
enum DetailsModuleFactory {
    private enum CacheConfiguration {
        static let cacheDirectory = "RickAndMortyApp"
        static let cacheFile = "episodes.json"
    }

    private static let episodeCacheLoader: CacheFirstLoader<EpisodeDTO> = {
        let dataStore = FileDataStore(fileURL: makeCacheFileURL())
        let cacheStore = CodableCacheStore<EpisodeDTO>(dataStore: dataStore)
        return CacheFirstLoader(
            store: cacheStore,
            policy: .default
        )
    }()

    static func make(
        character: Character,
        router: any DetailsRouting
    ) -> DetailsViewController {
        let transport = AlamofireHTTPTransport(session: Session.default)
        let apiClient = DefaultAPIClient(
            baseURL: APIEndpoint.baseURL,
            transport: transport
        )
        let remoteDataSource = EpisodeDataSource(apiClient: apiClient)
        let repository = EpisodeRepositoryImpl(
            remoteDataSource: remoteDataSource,
            cacheLoader: episodeCacheLoader
        )
        let useCase = GetFirstSeenInUseCase(repository: repository)
        let presenter = DetailsPresenter(
            mapper: DetailsViewModelMapper(),
            errorMapper: ErrorViewModelMapper()
        )
        let interactor = DetailsInteractor(
            character: character,
            getFirstSeenInUseCase: useCase,
            presenter: presenter
        )
        let viewController = DetailsViewController(
            interactor: interactor,
            router: router,
            detailsView: DetailsView()
        )
        presenter.view = viewController
        return viewController
    }

    private static func makeCacheFileURL() -> URL {
        let cacheURL = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first ?? FileManager.default.temporaryDirectory

        return cacheURL
            .appendingPathComponent(CacheConfiguration.cacheDirectory)
            .appendingPathComponent(CacheConfiguration.cacheFile)
    }
}
