import Alamofire
import Foundation
import UIKit

@MainActor
enum HomeModuleFactory {
    private enum Strings {
        static let cacheDirectory = "RickAndMortyApp"
        static let cacheFile = "characters-page-one.json"
    }

    static func make() -> HomeViewController {
        ImageCacheConfigurator.configure(
            ttl: CharacterCachePolicy.default.ttl
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
        let localDataSource = CharacterLocalDataSource(
            dataStore: dataStore
        )
        let repository = CharactersRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
            cachePolicy: .default
        )
        let useCase = GetCharactersUseCase(
            repository: repository
        )
        let interactor = HomeInteractor(
            getCharactersUseCase: useCase
        )
        let router = HomeRouter()
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
        router.viewController = viewController
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
