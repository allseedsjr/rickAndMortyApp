@testable import RickAndMortyApp

final class DetailsViewModelMapperSpy: DetailsViewModelMapping {
    private(set) var receivedCharacters: [Character] = []
    private(set) var receivedFirstSeenIn: [FirstSeenIn] = []
    var characterViewModel = DetailsViewModel.fixture()
    var firstSeenInViewModel = FirstSeenInViewModel.fixture()

    func map(_ character: Character) -> DetailsViewModel {
        receivedCharacters.append(character)
        return characterViewModel
    }

    func map(_ firstSeenIn: FirstSeenIn) -> FirstSeenInViewModel {
        receivedFirstSeenIn.append(firstSeenIn)
        return firstSeenInViewModel
    }
}
