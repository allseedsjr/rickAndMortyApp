@testable import RickAndMortyApp

@MainActor
final class HomeInteractorSpy: HomeBusinessLogic {
    private(set) var loadInitialCharactersCallCount = 0
    private(set) var retryInitialLoadingCallCount = 0
    private(set) var loadNextPageCallCount = 0
    private(set) var retryNextPageCallCount = 0
    private(set) var dismissPaginationErrorCallCount = 0
    private(set) var receivedSearchQueries: [String] = []
    private(set) var receivedCharacterIDs: [Int] = []

    func loadInitialCharacters() { loadInitialCharactersCallCount += 1 }
    func retryInitialLoading() { retryInitialLoadingCallCount += 1 }
    func loadNextPage() { loadNextPageCallCount += 1 }
    func retryNextPage() { retryNextPageCallCount += 1 }
    func dismissPaginationError() { dismissPaginationErrorCallCount += 1 }
    func searchCharacters(with query: String) { receivedSearchQueries.append(query) }
    func selectCharacter(id: Int) { receivedCharacterIDs.append(id) }
}
