import UIKit

protocol CharacterCellViewModelMapping {
    func map(_ character: Character) -> CharacterCellViewModel
}

struct CharacterCellViewModelMapper: CharacterCellViewModelMapping {
    private enum Strings {
        static let aliveStatus = "alive"
        static let deadStatus = "dead"
    }

    func map(_ character: Character) -> CharacterCellViewModel {
        CharacterCellViewModel(
            name: character.name,
            status: character.status,
            species: character.species,
            statusColor: statusColor(for: character.status),
            imageURL: imageURL(from: character.imageURL)
        )
    }

    private func statusColor(for status: String) -> UIColor {
        switch status.lowercased() {
        case Strings.aliveStatus:
            return .systemGreen
        case Strings.deadStatus:
            return .systemRed
        default:
            return .systemGray
        }
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
