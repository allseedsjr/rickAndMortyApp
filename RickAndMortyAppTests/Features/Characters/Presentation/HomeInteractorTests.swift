import Testing
@testable import RickAndMortyApp

@Suite("HomeInteractor", .serialized)
@MainActor
final class HomeInteractorTests {
    private let useCaseSpy = GetCharactersUseCaseSpy()
    private let presenterSpy = HomePresenterSpy()
    private let paginationStateSpy = HomePaginationStateSpy()
    private let searchFilterSpy = CharacterSearchFilterSpy()
    private lazy var sut = HomeInteractor(
        getCharactersUseCase: useCaseSpy,
        presenter: presenterSpy,
        paginationState: paginationStateSpy,
        searchFilter: searchFilterSpy
    )

    @Test
    func testLoadInitialCharacters_StartsLoadingAndRequestsFirstPage() async {
        useCaseSpy.result = .success(.fixture())
        await waitForCharacters { sut.loadInitialCharacters() }
        #expect(presenterSpy.presentLoadingCallCount == 1)
        #expect(useCaseSpy.receivedPages == [1])
    }

    @Test
    func testLoadInitialCharacters_WhenSuccessful_PresentsCharacters() async {
        useCaseSpy.result = .success(.fixture(characters: [.fixture(name: "Morty")]))
        await waitForCharacters { sut.loadInitialCharacters() }
        #expect(presenterSpy.presentedCharacters.last?.characters.map(\.name) == ["Morty"])
        #expect(paginationStateSpy.receivedFinishedPages.last?.page == 1)
    }

    @Test
    func testLoadNextPage_WhenAvailable_PresentsLoadingAndAdditionalCharacters() async {
        useCaseSpy.result = .success(.fixture(characters: [.fixture(name: "Summer")]))
        await waitForAdditionalCharacters { sut.loadNextPage() }
        #expect(useCaseSpy.receivedPages == [2])
        #expect(presenterSpy.paginationLoadingStates == [true])
        #expect(presenterSpy.presentedAdditionalCharacters.last?.map(\.name) == ["Summer"])
    }

    @Test
    func testLoadNextPage_WhenUnavailable_DoesNothing() {
        paginationStateSpy.nextPage = nil
        sut.loadNextPage()
        #expect(useCaseSpy.receivedPages.isEmpty)
        #expect(presenterSpy.paginationLoadingStates.isEmpty)
    }

    @Test
    func testLoadInitialCharacters_WhenRequestFails_PresentsInitialError() async {
        useCaseSpy.result = .failure(HomeInteractorTestError.expected)
        await waitForError { sut.loadInitialCharacters() }
        #expect(presenterSpy.presentedErrors.last?.isPagination == false)
        #expect(paginationStateSpy.receivedFailureKinds == [false])
    }

    @Test
    func testRetryInitialLoading_StartsInitialLoadingAgain() async {
        useCaseSpy.result = .success(.fixture())
        await waitForCharacters { sut.retryInitialLoading() }
        #expect(useCaseSpy.receivedPages == [1])
        #expect(presenterSpy.presentLoadingCallCount == 1)
    }

    @Test
    func testLoadNextPage_WhenRequestFails_PresentsPaginationError() async {
        useCaseSpy.result = .failure(HomeInteractorTestError.expected)
        await waitForError { sut.loadNextPage() }
        #expect(presenterSpy.paginationLoadingStates == [true, false])
        #expect(presenterSpy.presentedErrors.last?.isPagination == true)
    }

    @Test
    func testRetryNextPage_WhenStateAllowsRetry_LoadsNextPage() async {
        paginationStateSpy.prepareRetryResult = true
        useCaseSpy.result = .success(.fixture())
        await waitForAdditionalCharacters { sut.retryNextPage() }
        #expect(paginationStateSpy.prepareRetryCallCount == 1)
        #expect(useCaseSpy.receivedPages == [2])
    }

    @Test
    func testResponseRejectedByPaginationState_IsNotPresented() async {
        paginationStateSpy.canHandleResponse = false
        useCaseSpy.result = .success(.fixture())
        await waitForRequestToComplete { sut.loadInitialCharacters() }
        #expect(presenterSpy.presentedCharacters.isEmpty)
        #expect(paginationStateSpy.receivedFinishedPages.isEmpty)
    }

    @Test
    func testCancelledRequest_DoesNotPresentError() async {
        useCaseSpy.result = .failure(CancellationError())
        sut.loadInitialCharacters()
        await Task.yield()
        await Task.yield()
        #expect(presenterSpy.presentedErrors.isEmpty)
    }

    @Test
    func testSearchCharacters_FiltersLoadedCharactersAndPresentsResult() async {
        useCaseSpy.result = .success(.fixture(characters: [.fixture(name: "Rick")]))
        await waitForCharacters { sut.loadInitialCharacters() }
        searchFilterSpy.result = [.fixture(name: "Filtered Rick")]

        sut.searchCharacters(with: "  Rick  ")

        #expect(searchFilterSpy.receivedQueries.last == "Rick")
        #expect(presenterSpy.presentedCharacters.last?.characters.first?.name == "Filtered Rick")
        #expect(presenterSpy.presentedCharacters.last?.query == "Rick")
    }

    @Test
    func testLoadNextPage_WithActiveSearch_PresentsCompleteFilteredResult() async {
        useCaseSpy.result = .success(.fixture(characters: [.fixture(id: 1)]))
        await waitForCharacters { sut.loadInitialCharacters() }
        searchFilterSpy.result = [.fixture(name: "Filtered")]
        sut.searchCharacters(with: "rick")

        await waitForCharacters { sut.loadNextPage() }

        #expect(presenterSpy.presentedAdditionalCharacters.isEmpty)
        #expect(searchFilterSpy.receivedCharacters.last?.count == 2)
    }

    @Test
    func testSelectCharacter_WhenLoaded_PresentsSelectedCharacter() async {
        let character = Character.fixture(id: 42)
        useCaseSpy.result = .success(.fixture(characters: [character]))
        await waitForCharacters { sut.loadInitialCharacters() }
        sut.selectCharacter(id: 42)
        #expect(presenterSpy.selectedCharacters == [character])
    }

    @Test
    func testSelectCharacter_WhenUnknown_DoesNotPresentSelection() {
        sut.selectCharacter(id: 999)
        #expect(presenterSpy.selectedCharacters.isEmpty)
    }

    @Test
    func testRetryAndDismissPaginationError_ForwardStateTransitions() async {
        paginationStateSpy.prepareRetryResult = false
        sut.retryNextPage()
        sut.dismissPaginationError()
        #expect(paginationStateSpy.prepareRetryCallCount == 1)
        #expect(paginationStateSpy.dismissErrorCallCount == 1)
    }

    private func waitForCharacters(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            presenterSpy.onPresentCharacters = { continuation.resume() }
            perform()
        }
    }

    private func waitForAdditionalCharacters(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            presenterSpy.onPresentAdditionalCharacters = { continuation.resume() }
            perform()
        }
    }

    private func waitForError(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            presenterSpy.onPresentError = { continuation.resume() }
            perform()
        }
    }

    private func waitForRequestToComplete(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            useCaseSpy.onExecuteCompleted = { continuation.resume() }
            perform()
        }
        await Task.yield()
    }
}

private enum HomeInteractorTestError: Error { case expected }
