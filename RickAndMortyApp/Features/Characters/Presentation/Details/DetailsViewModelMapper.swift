import UIKit

protocol DetailsViewModelMapping {
    func map(_ character: Character) -> DetailsViewModel
    func map(_ firstSeenIn: FirstSeenIn) -> FirstSeenInViewModel
}

struct DetailsViewModelMapper: DetailsViewModelMapping {
    private let attributeMapper: any CharacterAttributeViewModelMapping

    init(
        attributeMapper: any CharacterAttributeViewModelMapping = CharacterAttributeViewModelMapper()
    ) {
        self.attributeMapper = attributeMapper
    }

    func map(_ character: Character) -> DetailsViewModel {
        DetailsViewModel(
            name: character.name,
            status: attributeMapper.statusText(for: character.status),
            statusColor: attributeMapper.statusColor(for: character.status),
            species: attributeMapper.speciesText(for: character.species),
            gender: attributeMapper.genderText(for: character.gender),
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
