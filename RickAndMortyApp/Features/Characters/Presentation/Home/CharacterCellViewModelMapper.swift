import UIKit

protocol CharacterCellViewModelMapping {
    func map(_ character: Character) -> CharacterCellViewModel
}

struct CharacterCellViewModelMapper: CharacterCellViewModelMapping {
    private let attributeMapper: any CharacterAttributeViewModelMapping

    init(
        attributeMapper: any CharacterAttributeViewModelMapping = CharacterAttributeViewModelMapper()
    ) {
        self.attributeMapper = attributeMapper
    }

    func map(_ character: Character) -> CharacterCellViewModel {
        CharacterCellViewModel(
            id: character.id,
            name: character.name,
            status: attributeMapper.statusText(for: character.status),
            species: attributeMapper.speciesText(for: character.species),
            statusColor: attributeMapper.statusColor(for: character.status),
            imageURL: imageURL(from: character.imageURL)
        )
    }

    private func imageURL(from value: String) -> URL? {
        guard let url = URL(string: value),
              let scheme = url.scheme?.lowercased(),
              ["http", "https"].contains(scheme),
              url.host != nil else {
            return nil
        }

        return url
    }
}
