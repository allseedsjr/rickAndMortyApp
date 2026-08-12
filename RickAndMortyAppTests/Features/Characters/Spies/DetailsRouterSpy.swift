@testable import RickAndMortyApp

@MainActor
final class DetailsRouterSpy: DetailsRouting {
    private(set) var showHomeCallCount = 0

    func showHome() {
        showHomeCallCount += 1
    }
}
