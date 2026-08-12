@testable import RickAndMortyApp

final class HomePaginationStateSpy: HomePaginationStateHandling {
    var initialPage = 1
    var nextPage: Int? = 2
    var canHandleResponse = true
    var prepareRetryResult = true

    private(set) var startInitialLoadingCallCount = 0
    private(set) var startNextPageLoadingCallCount = 0
    private(set) var receivedResponsePages: [Int] = []
    private(set) var receivedFinishedPages: [(page: Int, hasNextPage: Bool)] = []
    private(set) var receivedFailureKinds: [Bool] = []
    private(set) var prepareRetryCallCount = 0
    private(set) var dismissErrorCallCount = 0

    func startInitialLoading() -> Int {
        startInitialLoadingCallCount += 1
        return initialPage
    }

    func startNextPageLoading() -> Int? {
        startNextPageLoadingCallCount += 1
        return nextPage
    }

    func canHandleResponse(page: Int) -> Bool {
        receivedResponsePages.append(page)
        return canHandleResponse
    }

    func finish(page: Int, hasNextPage: Bool) {
        receivedFinishedPages.append((page, hasNextPage))
    }

    func fail(wasPagination: Bool) {
        receivedFailureKinds.append(wasPagination)
    }

    func prepareRetry() -> Bool {
        prepareRetryCallCount += 1
        return prepareRetryResult
    }

    func dismissError() {
        dismissErrorCallCount += 1
    }
}
