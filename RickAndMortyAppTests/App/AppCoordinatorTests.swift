import Testing
import UIKit
@testable import RickAndMortyApp

@Suite("AppCoordinator", .serialized)
@MainActor
final class AppCoordinatorTests {
    private let navigationController = UINavigationController()
    private lazy var sut = AppCoordinator(
        navigationController: navigationController
    )

    @Test
    func testStart_SetsHomeAsRootViewController() {
        sut.start()

        #expect(navigationController.viewControllers.count == 1)
        #expect(navigationController.viewControllers.first is HomeViewController)
    }

    @Test
    func testShowDetails_PushesDetailsViewController() {
        sut.start()

        sut.showDetails(for: .fixture())

        #expect(navigationController.viewControllers.count == 2)
        #expect(navigationController.topViewController is DetailsViewController)
    }

    @Test
    func testShowHome_PopsDetailsViewController() {
        sut.start()
        sut.showDetails(for: .fixture())

        sut.showHome()

        #expect(navigationController.viewControllers.count == 1)
        #expect(navigationController.topViewController is HomeViewController)
    }
}
