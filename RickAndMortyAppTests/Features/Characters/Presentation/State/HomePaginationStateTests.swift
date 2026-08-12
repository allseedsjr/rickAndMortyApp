import Testing
@testable import RickAndMortyApp

@Suite("HomePaginationState")
struct HomePaginationStateTests {
    @Test
    func testStartInitialLoading_ResetsStateAndReturnsFirstPage() {
        var sut = HomePaginationState()

        let page = sut.startInitialLoading()

        #expect(page == 1)
        #expect(sut.currentPage == 0)
        #expect(sut.hasNextPage)
        #expect(sut.isLoading)
        #expect(!sut.requiresRetry)
    }

    @Test
    func testStartNextPageLoading_AfterFirstPageFinishes_ReturnsSecondPage() {
        var sut = HomePaginationState()
        _ = sut.startInitialLoading()
        sut.finish(page: 1, hasNextPage: true)

        let page = sut.startNextPageLoading()

        #expect(page == 2)
        #expect(sut.isLoading)
    }

    @Test
    func testStartNextPageLoading_WhileLoading_ReturnsNil() {
        var sut = HomePaginationState()
        _ = sut.startInitialLoading()

        let page = sut.startNextPageLoading()

        #expect(page == nil)
    }

    @Test
    func testStartNextPageLoading_WhenThereIsNoNextPage_ReturnsNil() {
        var sut = HomePaginationState()
        _ = sut.startInitialLoading()
        sut.finish(page: 1, hasNextPage: false)

        let page = sut.startNextPageLoading()

        #expect(page == nil)
    }

    @Test
    func testFail_WhenPaginationFails_RequiresRetryAndStopsLoading() {
        var sut = HomePaginationState()
        _ = sut.startInitialLoading()
        sut.finish(page: 1, hasNextPage: true)
        _ = sut.startNextPageLoading()

        sut.fail(wasPagination: true)

        #expect(!sut.isLoading)
        #expect(sut.requiresRetry)
        #expect(sut.startNextPageLoading() == nil)
    }

    @Test
    func testPrepareRetry_WhenRetryIsRequired_UnblocksNextPage() {
        var sut = HomePaginationState()
        _ = sut.startInitialLoading()
        sut.finish(page: 1, hasNextPage: true)
        sut.fail(wasPagination: true)

        let shouldRetry = sut.prepareRetry()
        let page = sut.startNextPageLoading()

        #expect(shouldRetry)
        #expect(page == 2)
    }

    @Test
    func testDismissError_WhenRetryIsRequired_UnblocksPagination() {
        var sut = HomePaginationState()
        _ = sut.startInitialLoading()
        sut.finish(page: 1, hasNextPage: true)
        sut.fail(wasPagination: true)

        sut.dismissError()

        #expect(!sut.requiresRetry)
        #expect(sut.startNextPageLoading() == 2)
    }

    @Test
    func testCanHandleResponse_OnlyAcceptsExpectedNextPage() {
        var sut = HomePaginationState()
        _ = sut.startInitialLoading()
        sut.finish(page: 1, hasNextPage: true)

        #expect(sut.canHandleResponse(page: 2))
        #expect(!sut.canHandleResponse(page: 1))
        #expect(!sut.canHandleResponse(page: 3))
    }
}
