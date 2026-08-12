import Testing
import UIKit
@testable import RickAndMortyApp

@Suite("DetailsViewController")
@MainActor
final class DetailsViewControllerTests {
    private let interactorSpy = DetailsInteractorSpy()
    private let routerSpy = DetailsRouterSpy()
    private lazy var detailsView = DetailsView()
    private lazy var sut = DetailsViewController(
        interactor: interactorSpy,
        router: routerSpy,
        detailsView: detailsView
    )

    @Test
    func testViewDidLoad_RequestsDetails() {
        sut.loadViewIfNeeded()
        #expect(interactorSpy.loadDetailsCallCount == 1)
    }

    @Test
    func testBackButtonTap_RoutesToHome() {
        sut.loadViewIfNeeded()
        detailsView.backButton.sendActions(for: .touchUpInside)
        #expect(routerSpy.showHomeCallCount == 1)
    }

    @Test
    func testInit_DoesNotRetainRouter() {
        weak var weakRouter: DetailsRouterSpy?
        let sut: DetailsViewController = {
            let router = DetailsRouterSpy()
            weakRouter = router
            return DetailsViewController(
                interactor: interactorSpy,
                router: router,
                detailsView: DetailsView()
            )
        }()

        #expect(weakRouter == nil)
        #expect(sut.router == nil)
    }
}
