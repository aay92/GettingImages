import UIKit

// MARK: - UserImageElement
struct UserImageElement: Codable, Hashable {
    let albumID, id: Int?
    let title: String?
    let url, thumbnailURL: String?

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}

struct UserImageElementAlbom: Codable {
    let results: [UserImageElement]
}
