import Alamofire
import UIKit

@MainActor
enum DetailsModuleFactory {
    static func make(
        character: Character,
        router: any DetailsRouting
    ) -> DetailsViewController {
        let transport = AlamofireHTTPTransport(session: Session.default)
        let apiClient = DefaultAPIClient(
            baseURL: APIEndpoint.baseURL,
            transport: transport
        )
        let dataSource = EpisodeDataSource(apiClient: apiClient)
        let repository = EpisodeRepositoryImpl(dataSource: dataSource)
        let useCase = GetFirstSeenInUseCase(repository: repository)
        let interactor = DetailsInteractor(getFirstSeenInUseCase: useCase)
        let presenter = DetailsPresenter(
            character: character,
            interactor: interactor,
            mapper: DetailsViewModelMapper(),
            errorMapper: ErrorViewModelMapper(),
            router: router
        )
        let viewController = DetailsViewController(
            presenter: presenter,
            detailsView: DetailsView()
        )
        presenter.view = viewController
        return viewController
    }
}
