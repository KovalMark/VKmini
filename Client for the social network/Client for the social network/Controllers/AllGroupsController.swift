import UIKit
import RealmSwift

// MARK: - AllGroupsController for group
class AllGroupsController: UITableViewController {
    
    private let groupsVK = GroupVKService()
    var group: [GroupVKArray] = []
    let realm = RealmCacheService()
    private var imageService: ImageService?
    private var groupResponse: Results<GroupVKArray>? {
        realm.read(GroupVKArray.self)
    }
    private var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGroupDataRealm()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsCell", for: indexPath) as? AllGroupsCell else {
            preconditionFailure("Failed to create a cell")
        }
        let groups = group[indexPath.row]
        
        cell.labelAllGroups.text = groups.name
        cell.ImageAllGroups.loadImageCache(groups.photo)
        
        return cell
    }
    
    func loadGroupData() {
        do {
            let realm = try Realm()
            let userVKArray = realm.objects(GroupVKArray.self)
            self.group = Array(userVKArray)
        } catch {
            print(error)
        }
    }
    
    func loadGroupDataRealm() {
        groupsVK.groupAdd { [weak self] group in
            self?.loadGroupData()
            self?.tableView?.reloadData()
        }
    }
}
