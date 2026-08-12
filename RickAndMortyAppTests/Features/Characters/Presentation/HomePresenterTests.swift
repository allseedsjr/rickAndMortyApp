import Testing
@testable import RickAndMortyApp

@Suite("HomePresenter", .serialized)
@MainActor
final class HomePresenterTests {
    private let interactorSpy = HomeInteractorSpy()
    private let mapperSpy = CharacterCellViewModelMapperSpy()
    private let viewSpy = HomeDisplaySpy()

    private lazy var sut: HomePresenter = {
        let presenter = HomePresenter(
            interactor: interactorSpy,
            viewModelMapper: mapperSpy
        )
        presenter.view = viewSpy
        return presenter
    }()

    @Test
    func testViewDidLoad_StartsLoadingAndRequestsFirstPage() async {
        interactorSpy.result = .success(.fixture())

        await waitForCharactersToBeShown {
            sut.viewDidLoad()
        }

        #expect(viewSpy.showLoadingCallCount == 1)
        #expect(interactorSpy.receivedPages == [1])
    }

    @Test
    func testViewDidLoad_WhenRequestSucceeds_MapsAndShowsCharacters() async {
        let character = Character.fixture(name: "Morty Smith")
        mapperSpy.viewModel = .fixture(name: "Presented Morty")
        interactorSpy.result = .success(.fixture(characters: [character]))

        await waitForCharactersToBeShown {
            sut.viewDidLoad()
        }

        #expect(mapperSpy.receivedCharacters.map(\.name) == ["Morty Smith"])
        #expect(viewSpy.shownCharacters.first?.first?.name == "Presented Morty")
    }

    @Test
    func testViewDidLoad_WhenRequestFails_ShowsError() async {
        interactorSpy.result = .failure(HomePresenterTestError.expected)

        await waitForInitialError {
            sut.viewDidLoad()
        }

        #expect(viewSpy.errorMessages.count == 1)
    }

    @Test
    func testRetryInitialLoading_RequestsFirstPageAgain() async {
        interactorSpy.result = .success(.fixture())

        await waitForCharactersToBeShown {
            sut.retryInitialLoading()
        }

        #expect(interactorSpy.receivedPages == [1])
    }

    private func waitForCharactersToBeShown(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            viewSpy.onShowCharacters = { continuation.resume() }
            perform()
        }
    }

    private func waitForInitialError(perform: () -> Void) async {
        await withCheckedContinuation { continuation in
            viewSpy.onShowError = { continuation.resume() }
            perform()
        }
    }
}

private enum HomePresenterTestError: Error {
    case expected
}
