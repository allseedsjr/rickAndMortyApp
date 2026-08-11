import Foundation

struct CharacterResponseDTO: Codable {
    let info: PageInfoDTO
    let results: [CharacterDTO]
}
