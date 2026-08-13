import UIKit

protocol CharacterAttributeViewModelMapping {
    func statusText(for status: CharacterStatus) -> String
    func statusColor(for status: CharacterStatus) -> UIColor
    func genderText(for gender: CharacterGender) -> String
    func speciesText(for species: CharacterSpecies) -> String
}

struct CharacterAttributeViewModelMapper: CharacterAttributeViewModelMapping {
    func statusText(for status: CharacterStatus) -> String {
        switch status {
        case .alive: Strings.CharacterStatus.alive
        case .dead: Strings.CharacterStatus.dead
        case .unknown: Strings.CharacterStatus.unknown
        }
    }

    func statusColor(for status: CharacterStatus) -> UIColor {
        switch status {
        case .alive: .systemGreen
        case .dead: .systemRed
        case .unknown: .systemGray
        }
    }

    func genderText(for gender: CharacterGender) -> String {
        switch gender {
        case .female: Strings.CharacterGender.female
        case .male: Strings.CharacterGender.male
        case .genderless: Strings.CharacterGender.genderless
        case .unknown: Strings.CharacterGender.unknown
        }
    }

    func speciesText(for species: CharacterSpecies) -> String {
        switch species {
        case .human: Strings.CharacterSpecies.human
        case .alien: Strings.CharacterSpecies.alien
        case .humanoid: Strings.CharacterSpecies.humanoid
        case .animal: Strings.CharacterSpecies.animal
        case .robot: Strings.CharacterSpecies.robot
        case .mythologicalCreature: Strings.CharacterSpecies.mythologicalCreature
        case .poopybutthole: Strings.CharacterSpecies.poopybutthole
        case .cronenberg: Strings.CharacterSpecies.cronenberg
        case .disease: Strings.CharacterSpecies.disease
        case .planet: Strings.CharacterSpecies.planet
        case .unknown: Strings.CharacterSpecies.unknown
        case .other(let value): value
        }
    }
}
