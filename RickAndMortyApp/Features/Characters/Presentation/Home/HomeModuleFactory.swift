import Alamofire
import Foundation
import UIKit

@MainActor
enum HomeModuleFactory {
    private enum Strings {
        static let cacheDirectory = "RickAndMortyApp"
        static let cacheFile = "characters-page-one.json"
    }

    static func make(router: any HomeRouting) -> HomeViewController {
        ImageCacheConfigurator.configure(
            ttl: CachePolicy.default.ttl
        )

        let transport = AlamofireHTTPTransport(
            session: Session.default
        )
        let apiClient = DefaultAPIClient(
            baseURL: APIEndpoint.baseURL,
            transport: transport
        )
        let remoteDataSource = CharacterDataSource(
            apiClient: apiClient
        )
        let dataStore = FileDataStore(
            fileURL: makeCacheFileURL()
        )
        let cacheStore = CodableCacheStore<CharacterResponseDTO>(
            dataStore: dataStore
        )
        let cacheLoader = CacheFirstLoader(
            store: cacheStore,
            policy: .default
        )
        let repository = CharactersRepositoryImpl(
            remoteDataSource: remoteDataSource,
            cacheLoader: cacheLoader
        )
        let useCase = GetCharactersUseCase(
            repository: repository
        )
        let interactor = HomeInteractor(
            getCharactersUseCase: useCase
        )
        let presenter = HomePresenter(
            interactor: interactor,
            viewModelMapper: CharacterCellViewModelMapper(),
            paginationState: HomePaginationState(),
            searchFilter: CharacterSearchFilter(),
            errorMapper: ErrorViewModelMapper(),
            router: router
        )
        let viewController = HomeViewController(
            presenter: presenter,
            homeView: HomeView()
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
            .appendingPathComponent(Strings.cacheDirectory)
            .appendingPathComponent(Strings.cacheFile)
    }
}
