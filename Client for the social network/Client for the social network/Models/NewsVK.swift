import UIKit

// MARK: - ResponseNews
struct NewsResponse: Codable {
    let response: ItemsNews
}

struct ItemsNews: Codable {
    let items: [NewsVK]
    let profiles: [ProfileNews]
    let groups: [GroupNews]
    let nextFrom: String?
    
    enum CodingKeys: String, CodingKey {
        case items
        case profiles
        case groups
        case nextFrom = "next_from"
    }
}

struct ProfileNews: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarURL = "photo_100"
    }
}

struct GroupNews: Codable {
    let id: Int
    let name: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarURL = "photo_100"
    }
}

// MARK: - NewsVK model
struct NewsVK: Codable {
    let postID: Int
    let text: String
    let date: Double
    let attachments: [Attachment]?
    let likes: LikeModel
    let comments: CommentModel
    let sourceID: Int
    var avatarURL: String?
    var creatorName: String?
    var photosURL: [String]? {
        get {
            let photosURL = attachments?.compactMap{ $0.photo?.sizes?.last?.url }
            return photosURL
        }
    }
    
    var aspectRatio: CGFloat {
        get {
            let aspectRatio = attachments?.compactMap{ $0.photo?.sizes?.last?.aspectRatio }.last
            return aspectRatio ?? 1
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case text
        case date
        case likes
        case comments
        case attachments
        case sourceID = "source_id"
        case avatarURL
        case creatorName
    }
    
    func getStringDate() -> String {
        let dateFormatter = DateFormatterVK()
        return dateFormatter.convertDate(timeIntervalSince1970: date)
    }
}

struct Attachment: Codable {
    let type: String?
    let photo: PhotoNews?
}

struct LikeModel: Codable {
    let count: Int
}

struct CommentModel: Codable {
    let count: Int
}

struct PhotoNews: Codable {
    let id: Int?
    let ownerID: Int?
    let sizes: [SizeNews]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case sizes
    }
}

struct SizeNews: Codable {
    let type: String?
    let url: String?
    let width: Int?
    let height: Int?
    
    var aspectRatio: CGFloat { return CGFloat(height ?? 1)/CGFloat(width ?? 1) }
}

class DateFormatterVK {
    let dateFormatter = DateFormatter()
    
    func convertDate(timeIntervalSince1970: Double) -> String {
        dateFormatter.dateFormat = "MM-dd-yyyy HH.mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        return dateFormatter.string(from: date)
    }
}

