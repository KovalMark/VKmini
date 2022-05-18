import UIKit
import RealmSwift

// MARK: - PhotoVK model
struct PhotoVKResponse: Decodable {
    let response: PhotoVK
}

struct PhotoVK: Decodable {
    let items: [PhotoVKArray]
    let count: Int
}

struct PhotoVKArray: Decodable {
    let sizes: [SizesVKArray]
    
    enum CodingKeys: String, CodingKey {
        case sizes
    }
}

struct SizesVKArray: Decodable {
    let type: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case url
    }
}

