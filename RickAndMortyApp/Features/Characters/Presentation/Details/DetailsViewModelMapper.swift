import UIKit

protocol DetailsViewModelMapping {
    func map(_ character: Character) -> DetailsViewModel
    func map(_ firstSeenIn: FirstSeenIn) -> FirstSeenInViewModel
}

struct DetailsViewModelMapper: DetailsViewModelMapping {
    private enum Strings {
        static let alive = "alive"
        static let dead = "dead"
    }

    func map(_ character: Character) -> DetailsViewModel {
        DetailsViewModel(
            name: character.name,
            status: character.status,
            statusColor: statusColor(for: character.status),
            species: character.species,
            gender: character.gender,
            origin: character.originName,
            location: character.locationName,
            episodeCount: String(character.episodeCount),
            imageURL: validURL(from: character.imageURL)
        )
    }

    func map(_ firstSeenIn: FirstSeenIn) -> FirstSeenInViewModel {
        FirstSeenInViewModel(
            episode: "\(firstSeenIn.episodeName) (\(firstSeenIn.episodeCode))",
            airDate: firstSeenIn.airDate
        )
    }

    private func statusColor(for status: String) -> UIColor {
        switch status.lowercased() {
        case Strings.alive:
            return .systemGreen
        case Strings.dead:
            return .systemRed
        default:
            return .systemGray
        }
    }

    private func validURL(from value: String) -> URL? {
        guard let url = URL(string: value),
              let scheme = url.scheme?.lowercased(),
              ["http", "https"].contains(scheme),
              url.host != nil else {
            return nil
        }

        return url
    }
}
