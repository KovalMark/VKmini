import UIKit
import Alamofire
import RealmSwift

// MARK: - GroupService
final class GroupVKService {
    
    let baseUrl = "https://api.vk.com"
    let apiKey = Session.instance.token
    
    func loadVKGroup() {
        let path = "/method/groups.get"
        let methodName: Parameters = [
            "access_token": apiKey,
            "extended": "1",
            "v": "5.130"
        ]
        
        let url = baseUrl+path
        
        AF.request(url, method: .get, parameters: methodName).responseJSON { response in
            print("\nСписок групп\n")
            print(response.value ?? "")
        }
    }
    
    func groupAdd(completion: @escaping ([GroupVKArray]) -> Void){
        let path = "/method/groups.get"
        let methodName: Parameters = [
            "access_token": apiKey,
            "extended": "1",
            "v": "5.130"
        ]
        
        let url = baseUrl+path
        
        AF.request(url, method: .get, parameters: methodName).responseData { [ weak self ] response in
            guard let data = response.value else { return }
            let userArray = try! JSONDecoder().decode(GroupVKResponse.self, from: data)
            self?.saveGroupData(userArray.response.items)
            completion(userArray.response.items)
        }
    }
    
    func saveGroupData(_ userGroup: [GroupVKArray]) {
        do {
            let realm = try Realm()
            let oldGroupVKArray = realm.objects(GroupVKArray.self)
            realm.beginWrite()
            realm.delete(oldGroupVKArray)
            realm.add(userGroup)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
