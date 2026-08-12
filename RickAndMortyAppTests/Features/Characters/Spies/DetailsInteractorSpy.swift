@testable import RickAndMortyApp

@MainActor
final class DetailsInteractorSpy: DetailsBusinessLogic {
    private(set) var loadDetailsCallCount = 0
    private(set) var retryFirstSeenInCallCount = 0

    func loadDetails() {
        loadDetailsCallCount += 1
    }

    func retryFirstSeenIn() {
        retryFirstSeenInCallCount += 1
    }
}
