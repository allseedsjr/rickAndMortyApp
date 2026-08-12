protocol HomePaginationStateHandling {
    mutating func startInitialLoading() -> Int
    mutating func startNextPageLoading() -> Int?
    func canHandleResponse(page: Int) -> Bool
    mutating func finish(page: Int, hasNextPage: Bool)
    mutating func fail(wasPagination: Bool)
    mutating func prepareRetry() -> Bool
    mutating func dismissError()
}

struct HomePaginationState: HomePaginationStateHandling {
    private enum Constants {
        static let firstPage = 1
        static let pageIncrement = 1
    }

    private(set) var currentPage = 0
    private(set) var hasNextPage = true
    private(set) var isLoading = false
    private(set) var requiresRetry = false

    mutating func startInitialLoading() -> Int {
        currentPage = 0
        hasNextPage = true
        isLoading = true
        requiresRetry = false
        return Constants.firstPage
    }

    mutating func startNextPageLoading() -> Int? {
        guard !isLoading,
              !requiresRetry,
              hasNextPage,
              currentPage >= Constants.firstPage else {
            return nil
        }

        isLoading = true
        return currentPage + Constants.pageIncrement
    }

    func canHandleResponse(page: Int) -> Bool {
        page == currentPage + Constants.pageIncrement
    }

    mutating func finish(page: Int, hasNextPage: Bool) {
        currentPage = page
        self.hasNextPage = hasNextPage
        isLoading = false
        requiresRetry = false
    }

    mutating func fail(wasPagination: Bool) {
        isLoading = false
        requiresRetry = wasPagination
    }

    mutating func prepareRetry() -> Bool {
        guard requiresRetry else {
            return false
        }

        requiresRetry = false
        return true
    }

    mutating func dismissError() {
        requiresRetry = false
    }
}
