@testable import RickAndMortyApp

@MainActor
final class HomeRouterSpy: HomeRouting {
    private(set) var receivedCharacters: [Character] = []

    func showDetails(for character: Character) {
        receivedCharacters.append(character)
    }
}
