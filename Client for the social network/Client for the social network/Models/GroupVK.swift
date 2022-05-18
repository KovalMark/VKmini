import UIKit
import RealmSwift

// MARK: - GroupVK model
struct GroupVKResponse: Decodable {
    let response: GroupVK
}

struct GroupVK: Decodable {
    let items: [GroupVKArray]
}


class GroupVKArray: Object, Decodable {
    @objc dynamic var name = ""
    @objc dynamic var photo = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case photo = "photo_50"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.photo = try values.decode(String.self, forKey: .photo)
    }
}
