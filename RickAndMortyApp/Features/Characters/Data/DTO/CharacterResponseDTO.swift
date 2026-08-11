import Foundation

struct CharacterResponseDTO: Decodable {
    let info: PageInfoDTO
    let results: [CharacterDTO]
}
