import Testing
@testable import RickAndMortyApp

@Suite("HomePresenter")
@MainActor
final class HomePresenterTests {
    private let mapperSpy = CharacterCellViewModelMapperSpy()
    private let errorMapperSpy = ErrorViewModelMapperSpy()
    private let viewSpy = HomeDisplaySpy()
    private lazy var sut: HomePresenter = {
        let presenter = HomePresenter(
            viewModelMapper: mapperSpy,
            errorMapper: errorMapperSpy
        )
        presenter.view = viewSpy
        return presenter
    }()

    @Test
    func testPresentLoading_DisplaysLoading() {
        sut.presentLoading()
        #expect(viewSpy.showLoadingCallCount == 1)
    }

    @Test
    func testPresentCharacters_MapsAndDisplaysCharacters() {
        mapperSpy.viewModel = .fixture(name: "Presented Morty")

        sut.presentCharacters([.fixture(name: "Morty")], query: "")

        #expect(mapperSpy.receivedCharacters.map(\.name) == ["Morty"])
        #expect(viewSpy.shownCharacters.last?.first?.name == "Presented Morty")
        #expect(viewSpy.searchEmptyStateVisibility.last == false)
    }

    @Test
    func testPresentCharacters_WhenSearchHasNoResult_DisplaysEmptyState() {
        sut.presentCharacters([], query: "Rick")
        #expect(viewSpy.searchEmptyStateVisibility.last == true)
    }

    @Test
    func testPresentAdditionalCharacters_MapsAndDisplaysAppend() {
        mapperSpy.viewModel = .fixture(name: "Summer")
        sut.presentAdditionalCharacters([.fixture(name: "Summer")])
        #expect(viewSpy.appendedCharacters.last?.first?.name == "Summer")
    }

    @Test
    func testPresentError_WhenInitial_DisplaysInitialError() {
        sut.presentError(HomePresenterTestError.expected, isPagination: false)
        #expect(errorMapperSpy.receivedErrors.count == 1)
        #expect(viewSpy.errors == [errorMapperSpy.result])
    }

    @Test
    func testPresentError_WhenPagination_DisplaysPaginationError() {
        sut.presentError(HomePresenterTestError.expected, isPagination: true)
        #expect(viewSpy.paginationErrors == [errorMapperSpy.result])
    }

    @Test
    func testPresentSelectedCharacter_ForwardsCharacterToView() {
        let character = Character.fixture(id: 42)
        sut.presentSelectedCharacter(character)
        #expect(viewSpy.selectedCharacters == [character])
    }
}

private enum HomePresenterTestError: Error { case expected }
