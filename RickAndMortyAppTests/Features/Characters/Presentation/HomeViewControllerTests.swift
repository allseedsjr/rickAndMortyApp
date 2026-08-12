import Testing
import UIKit
@testable import RickAndMortyApp

@Suite("HomeViewController")
@MainActor
final class HomeViewControllerTests {
    private let interactorSpy = HomeInteractorSpy()
    private let routerSpy = HomeRouterSpy()
    private lazy var sut = HomeViewController(
        interactor: interactorSpy,
        router: routerSpy,
        homeView: HomeView()
    )

    @Test
    func testViewDidLoad_RequestsInitialCharacters() {
        sut.loadViewIfNeeded()
        #expect(interactorSpy.loadInitialCharactersCallCount == 1)
    }

    @Test
    func testUpdateSearchResults_ForwardsQueryToInteractor() {
        sut.loadViewIfNeeded()
        sut.searchController.searchBar.text = "Rick"
        sut.updateSearchResults(for: sut.searchController)
        #expect(interactorSpy.receivedSearchQueries.last == "Rick")
    }

    @Test
    func testDisplaySelectedCharacter_RoutesToDetails() {
        let character = Character.fixture(id: 42)
        sut.displaySelectedCharacter(character)
        #expect(routerSpy.receivedCharacters == [character])
    }

    @Test
    func testInit_DoesNotRetainRouter() {
        weak var weakRouter: HomeRouterSpy?
        let sut: HomeViewController = {
            let router = HomeRouterSpy()
            weakRouter = router
            return HomeViewController(
                interactor: interactorSpy,
                router: router,
                homeView: HomeView()
            )
        }()

        #expect(weakRouter == nil)
        #expect(sut.router == nil)
    }
}
