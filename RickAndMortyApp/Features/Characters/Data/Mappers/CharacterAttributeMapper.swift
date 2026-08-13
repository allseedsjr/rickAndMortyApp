import Foundation

enum CharacterAttributeMapper {
    static func status(from value: String) -> CharacterStatus {
        switch normalized(value) {
        case "alive": .alive
        case "dead": .dead
        default: .unknown
        }
    }

    static func gender(from value: String) -> CharacterGender {
        switch normalized(value) {
        case "female": .female
        case "male": .male
        case "genderless": .genderless
        default: .unknown
        }
    }

    static func species(from value: String) -> CharacterSpecies {
        switch normalized(value) {
        case "human": .human
        case "alien": .alien
        case "humanoid": .humanoid
        case "animal": .animal
        case "robot": .robot
        case "mythological creature": .mythologicalCreature
        case "poopybutthole": .poopybutthole
        case "cronenberg": .cronenberg
        case "disease": .disease
        case "planet": .planet
        case "unknown", "": .unknown
        default: .other(value.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }

    private static func normalized(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}
