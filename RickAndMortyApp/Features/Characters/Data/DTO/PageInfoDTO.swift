import Foundation

struct PageInfoDTO: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
