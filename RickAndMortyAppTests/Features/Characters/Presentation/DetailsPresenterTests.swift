import Testing
@testable import RickAndMortyApp

@Suite("DetailsPresenter", .serialized)
@MainActor
final class DetailsPresenterTests {
    private let interactorSpy = DetailsInteractorSpy()
    private let mapperSpy = DetailsViewModelMapperSpy()
    private let errorMapperSpy = ErrorViewModelMapperSpy()
    private let viewSpy = DetailsDisplaySpy()
    private let routerSpy = DetailsRouterSpy()

    private lazy var sut: DetailsPresenter = {
        let presenter = DetailsPresenter(
            character: .fixture(firstEpisodeID: 7),
            interactor: interactorSpy,
            mapper: mapperSpy,
            errorMapper: errorMapperSpy,
            router: routerSpy
        )
        presenter.view = viewSpy
        return presenter
    }()

    @Test
    func testViewDidLoad_ShowsCharacterAndLoadsFirstEpisode() async {
        await waitForFirstSeenIn {
            sut.viewDidLoad()
        }

        #expect(mapperSpy.receivedCharacters.count == 1)
        #expect(viewSpy.shownCharacters.count == 1)
        #expect(viewSpy.loadingCallCount == 1)
        #expect(interactorSpy.receivedEpisodeIDs == [7])
        #expect(viewSpy.shownFirstSeenIn.count == 1)
    }

    @Test
    func testViewDidLoad_WhenCharacterHasNoEpisode_ShowsUnavailable() {
        let presenter = DetailsPresenter(
            character: .fixture(firstEpisodeID: nil),
            interactor: interactorSpy,
            mapper: mapperSpy,
            errorMapper: errorMapperSpy,
            router: routerSpy
        )
        presenter.view = viewSpy

        presenter.viewDidLoad()

        #expect(viewSpy.unavailableCallCount == 1)
        #expect(interactorSpy.receivedEpisodeIDs.isEmpty)
    }

    @Test
    func testViewDidLoad_WhenRequestFails_ShowsMappedError() async {
        interactorSpy.result = .failure(AppError.timeout)

        await waitForError {
            sut.viewDidLoad()
        }

        #expect(errorMapperSpy.receivedErrors.count == 1)
        #expect(viewSpy.shownErrors == [errorMapperSpy.result])
    }

    @Test
    func testRetryFirstSeenIn_RequestsEpisodeAgain() async {
        await waitForFirstSeenIn {
            sut.viewDidLoad()
        }
        await waitForFirstSeenIn {
            sut.retryFirstSeenIn()
        }

        #expect(interactorSpy.receivedEpisodeIDs == [7, 7])
    }

    @Test
    func testDidTapBack_RoutesToHome() {
        sut.didTapBack()

        #expect(routerSpy.showHomeCallCount == 1)
    }

    private func waitForFirstSeenIn(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            viewSpy.onShowFirstSeenIn = { continuation.resume() }
            perform()
        }
    }

    private func waitForError(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            viewSpy.onShowError = { continuation.resume() }
            perform()
        }
    }
}
