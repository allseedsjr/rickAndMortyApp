import Testing
@testable import RickAndMortyApp

@Suite("DetailsPresenter")
@MainActor
final class DetailsPresenterTests {
    private let mapperSpy = DetailsViewModelMapperSpy()
    private let errorMapperSpy = ErrorViewModelMapperSpy()
    private let viewSpy = DetailsDisplaySpy()
    private lazy var sut: DetailsPresenter = {
        let presenter = DetailsPresenter(
            mapper: mapperSpy,
            errorMapper: errorMapperSpy
        )
        presenter.view = viewSpy
        return presenter
    }()

    @Test
    func testPresentCharacter_MapsAndDisplaysCharacter() {
        let character = Character.fixture(id: 7)
        sut.presentCharacter(character)
        #expect(mapperSpy.receivedCharacters == [character])
        #expect(viewSpy.displayedCharacters.count == 1)
    }

    @Test
    func testPresentFirstSeenInLoading_DisplaysLoading() {
        sut.presentFirstSeenInLoading()
        #expect(viewSpy.loadingCallCount == 1)
    }

    @Test
    func testPresentFirstSeenIn_MapsAndDisplaysValue() {
        let firstSeenIn = FirstSeenIn.fixture()
        sut.presentFirstSeenIn(firstSeenIn)
        #expect(mapperSpy.receivedFirstSeenIn == [firstSeenIn])
        #expect(viewSpy.displayedFirstSeenIn.count == 1)
    }

    @Test
    func testPresentFirstSeenInUnavailable_DisplaysUnavailable() {
        sut.presentFirstSeenInUnavailable()
        #expect(viewSpy.unavailableCallCount == 1)
    }

    @Test
    func testPresentFirstSeenInError_MapsAndDisplaysError() {
        sut.presentFirstSeenInError(AppError.timeout)
        #expect(errorMapperSpy.receivedErrors.count == 1)
        #expect(viewSpy.displayedErrors == [errorMapperSpy.result])
    }
}
