import UIKit

// MARK: - Singleton
class Session {
    static let instance = Session()
    private init() {}
    var token = "8ea3c7fafd7b82fea6a0f1beefd5b0f581028809c2653548555245b243cfa1058be818d9538d6de06721c"
    var userID = 0
}
