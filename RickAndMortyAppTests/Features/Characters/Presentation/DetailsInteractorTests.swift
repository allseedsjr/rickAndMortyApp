import Testing
@testable import RickAndMortyApp

@Suite("DetailsInteractor", .serialized)
@MainActor
final class DetailsInteractorTests {
    private let character = Character.fixture(id: 42, firstEpisodeID: 7)
    private let useCaseSpy = GetFirstSeenInUseCaseSpy()
    private let presenterSpy = DetailsPresenterSpy()
    private lazy var sut = DetailsInteractor(
        character: character,
        getFirstSeenInUseCase: useCaseSpy,
        presenter: presenterSpy
    )

    @Test
    func testLoadDetails_PresentsCharacterAndLoadsFirstSeenIn() async {
        let firstSeenIn = FirstSeenIn.fixture()
        useCaseSpy.result = .success(firstSeenIn)

        await waitForFirstSeenIn { sut.loadDetails() }

        #expect(presenterSpy.presentedCharacters == [character])
        #expect(presenterSpy.loadingCallCount == 1)
        #expect(useCaseSpy.receivedEpisodeIDs == [7])
        #expect(presenterSpy.presentedFirstSeenIn == [firstSeenIn])
    }

    @Test
    func testLoadDetails_WhenCharacterHasNoEpisode_PresentsUnavailable() {
        let character = Character.fixture(firstEpisodeID: nil)
        let sut = DetailsInteractor(
            character: character,
            getFirstSeenInUseCase: useCaseSpy,
            presenter: presenterSpy
        )

        sut.loadDetails()

        #expect(presenterSpy.presentedCharacters == [character])
        #expect(presenterSpy.unavailableCallCount == 1)
        #expect(useCaseSpy.receivedEpisodeIDs.isEmpty)
    }

    @Test
    func testLoadDetails_WhenRequestFails_PresentsError() async {
        useCaseSpy.result = .failure(DetailsInteractorTestError.expected)

        await waitForError { sut.loadDetails() }

        #expect(presenterSpy.presentedErrors.count == 1)
    }

    @Test
    func testRetryFirstSeenIn_ExecutesRequestAgain() async {
        useCaseSpy.result = .success(.fixture())
        await waitForFirstSeenIn { sut.loadDetails() }

        await waitForFirstSeenIn { sut.retryFirstSeenIn() }

        #expect(useCaseSpy.receivedEpisodeIDs == [7, 7])
    }

    @Test
    func testCancelledRequest_DoesNotPresentError() async {
        useCaseSpy.result = .failure(CancellationError())
        sut.loadDetails()
        await Task.yield()
        await Task.yield()
        #expect(presenterSpy.presentedErrors.isEmpty)
    }

    private func waitForFirstSeenIn(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            presenterSpy.onPresentFirstSeenIn = { continuation.resume() }
            perform()
        }
    }

    private func waitForError(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            presenterSpy.onPresentError = { continuation.resume() }
            perform()
        }
    }
}

private enum DetailsInteractorTestError: Error {
    case expected
}
