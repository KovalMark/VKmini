import UIKit
import Alamofire
import RealmSwift

// MARK: - FriendService
final class UserVKService {
    
    let baseUrl = "https://api.vk.com"
    let apiKey = Session.instance.token
    
    func loadVKFriend() {
        let path = "/method/friends.get"
        let methodName: Parameters = [
            "access_token": apiKey,
            "fields": "photo_50",
            "v": "5.130"
        ]
        
        let url = baseUrl+path
        
        AF.request(url, method: .get, parameters: methodName).responseJSON { response in
            print("\nСписок друзей\n")
            print(response.value ?? "")
        }
    }
    
    func friendAdd(completion: @escaping ([UserVKArray]) -> Void){
        let path = "/method/friends.get"
        let methodName: Parameters = [
            "access_token": apiKey,
            "fields": "photo_50",
            "v": "5.130"
        ]
        
        let url = baseUrl+path
        
        AF.request(url, method: .get, parameters: methodName).responseData { [ weak self ] response in
            guard let data = response.value else { return }
            guard let userArray = try? JSONDecoder().decode(UserVKResponse.self, from: data) else { return }
            self?.saveFriendData(userArray.response.items)
            completion(userArray.response.items)
        }
    }
    
    func saveFriendData(_ userFriend: [UserVKArray]) {
        do {
            let realm = try Realm()
            let oldUserVKArray = realm.objects(UserVKArray.self)
            realm.beginWrite()
            realm.delete(oldUserVKArray)
            realm.add(userFriend)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
