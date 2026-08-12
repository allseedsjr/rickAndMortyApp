@testable import RickAndMortyApp

final class CharacterCellViewModelMapperSpy: CharacterCellViewModelMapping {
    private(set) var receivedCharacters: [Character] = []
    var viewModel: CharacterCellViewModel = .fixture()

    func map(_ character: Character) -> CharacterCellViewModel {
        receivedCharacters.append(character)
        return viewModel
    }
}
