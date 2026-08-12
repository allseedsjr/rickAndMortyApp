import Testing
@testable import RickAndMortyApp

@Suite("HomePresenter", .serialized)
@MainActor
final class HomePresenterTests {
    private let interactorSpy = HomeInteractorSpy()
    private let mapperSpy = CharacterCellViewModelMapperSpy()
    private let paginationStateSpy = HomePaginationStateSpy()
    private let viewSpy = HomeDisplaySpy()

    private lazy var sut: HomePresenter = {
        let presenter = HomePresenter(
            interactor: interactorSpy,
            viewModelMapper: mapperSpy,
            paginationState: paginationStateSpy
        )
        presenter.view = viewSpy
        return presenter
    }()

    @Test
    func testViewDidLoad_StartsInitialLoadingAndRequestsFirstPage() async {
        interactorSpy.result = .success(.fixture())

        await waitForCharactersToBeShown {
            sut.viewDidLoad()
        }

        #expect(viewSpy.showLoadingCallCount == 1)
        #expect(paginationStateSpy.startInitialLoadingCallCount == 1)
        #expect(interactorSpy.receivedPages == [1])
    }

    @Test
    func testViewDidLoad_WhenRequestSucceeds_MapsAndShowsCharacters() async {
        let character = Character.fixture(name: "Morty Smith")
        let expectedViewModel = CharacterCellViewModel.fixture(name: "Presented Morty")
        interactorSpy.result = .success(
            .fixture(characters: [character], hasNextPage: true)
        )
        mapperSpy.viewModel = expectedViewModel

        await waitForCharactersToBeShown {
            sut.viewDidLoad()
        }

        #expect(mapperSpy.receivedCharacters.map(\.name) == ["Morty Smith"])
        #expect(viewSpy.shownCharacters.count == 1)
        #expect(viewSpy.shownCharacters.first?.first?.name == "Presented Morty")
        #expect(paginationStateSpy.receivedFinishedPages.first?.page == 1)
        #expect(paginationStateSpy.receivedFinishedPages.first?.hasNextPage == true)
    }

    @Test
    func testLoadNextPage_WhenPageIsAvailable_ShowsLoadingAndAppendsCharacters() async {
        let character = Character.fixture(name: "Summer Smith")
        let expectedViewModel = CharacterCellViewModel.fixture(name: "Summer Smith")
        interactorSpy.result = .success(.fixture(characters: [character]))
        mapperSpy.viewModel = expectedViewModel

        await waitForCharactersToBeAppended {
            sut.loadNextPage()
        }

        #expect(viewSpy.paginationLoadingStates == [true])
        #expect(interactorSpy.receivedPages == [2])
        #expect(viewSpy.appendedCharacters.first?.first?.name == "Summer Smith")
    }

    @Test
    func testViewDidLoad_WhenRequestFails_ShowsInitialError() async {
        interactorSpy.result = .failure(HomePresenterTestError.expected)

        await waitForInitialError {
            sut.viewDidLoad()
        }

        #expect(paginationStateSpy.receivedFailureKinds == [false])
        #expect(viewSpy.errorMessages.count == 1)
        #expect(viewSpy.paginationErrorMessages.isEmpty)
    }

    @Test
    func testLoadNextPage_WhenRequestFails_ShowsPaginationError() async {
        interactorSpy.result = .failure(HomePresenterTestError.expected)

        await waitForPaginationError {
            sut.loadNextPage()
        }

        #expect(paginationStateSpy.receivedFailureKinds == [true])
        #expect(viewSpy.paginationLoadingStates == [true, false])
        #expect(viewSpy.paginationErrorMessages.count == 1)
        #expect(viewSpy.errorMessages.isEmpty)
    }

    @Test
    func testRetryNextPage_WhenStateAllowsRetry_RequestsNextPage() async {
        interactorSpy.result = .success(.fixture())
        paginationStateSpy.prepareRetryResult = true

        await waitForCharactersToBeAppended {
            sut.retryNextPage()
        }

        #expect(paginationStateSpy.prepareRetryCallCount == 1)
        #expect(interactorSpy.receivedPages == [2])
    }

    @Test
    func testDismissPaginationError_ForwardsActionToState() {
        sut.dismissPaginationError()

        #expect(paginationStateSpy.dismissErrorCallCount == 1)
    }

    @Test
    func testRetryInitialLoading_RequestsFirstPageAgain() async {
        interactorSpy.result = .success(.fixture())

        await waitForCharactersToBeShown {
            sut.retryInitialLoading()
        }

        #expect(paginationStateSpy.startInitialLoadingCallCount == 1)
        #expect(interactorSpy.receivedPages == [1])
    }

    @Test
    func testLoadNextPage_WhenStateHasNoAvailablePage_DoesNotRequestOrShowLoading() {
        paginationStateSpy.nextPage = nil

        sut.loadNextPage()

        #expect(interactorSpy.receivedPages.isEmpty)
        #expect(viewSpy.paginationLoadingStates.isEmpty)
    }

    @Test
    func testRetryNextPage_WhenStateRejectsRetry_DoesNotRequestCharacters() {
        paginationStateSpy.prepareRetryResult = false

        sut.retryNextPage()

        #expect(interactorSpy.receivedPages.isEmpty)
    }

    @Test
    func testViewDidLoad_WhenStateRejectsResponse_DoesNotUpdateView() async {
        interactorSpy.result = .success(.fixture())
        paginationStateSpy.canHandleResponse = false

        await waitForRequestToFinishWithoutDisplaying {
            sut.viewDidLoad()
        }

        #expect(viewSpy.shownCharacters.isEmpty)
        #expect(viewSpy.appendedCharacters.isEmpty)
        #expect(paginationStateSpy.receivedFinishedPages.isEmpty)
    }

    private func waitForCharactersToBeShown(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            viewSpy.onShowCharacters = { continuation.resume() }
            perform()
        }
    }

    private func waitForCharactersToBeAppended(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            viewSpy.onAppendCharacters = { continuation.resume() }
            perform()
        }
    }

    private func waitForInitialError(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            viewSpy.onShowError = { continuation.resume() }
            perform()
        }
    }

    private func waitForPaginationError(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            viewSpy.onShowPaginationError = { continuation.resume() }
            perform()
        }
    }

    private func waitForRequestToFinishWithoutDisplaying(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            interactorSpy.onRequestCompleted = { continuation.resume() }
            perform()
        }
    }
}

private enum HomePresenterTestError: Error {
    case expected
}
