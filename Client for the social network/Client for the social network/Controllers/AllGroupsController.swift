import UIKit
import RealmSwift

// MARK: - AllGroupsController for group
class AllGroupsController: UITableViewController {
    
    private let groupsVK = GroupVKService()
    var group: [GroupVKArray] = []
    let realm = RealmCacheService()
    private var groupResponse: Results<GroupVKArray>? {
        realm.read(GroupVKArray.self)
    }
    private var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNotificationToken()
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
        cell.ImageAllGroups.loadImage(with: groups.photo)
        
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
    
    func createNotificationToken() {
        notificationToken = groupResponse?.observe { [ weak self ] result in
            guard let self = self else { return }
            switch result {
                // кейс подготовки к обновлению данных
            case .initial(let groupsData):
                print("\(groupsData.count)")
            case .update(let groups,
                         deletions: let deletions,
                         insertions: let insertions,
                         modifications: let modifications):
                let deletionsIndexPath = deletions.map { IndexPath(row: $0, section: 0) }
                let insertionsIndexPath = insertions.map { IndexPath(row: $0, section: 0) }
                let modificationsIndexPath = modifications.map { IndexPath(row: $0, section: 0) }
                
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: deletionsIndexPath, with: .automatic)
                    self.tableView.insertRows(at: insertionsIndexPath, with: .automatic)
                    self.tableView.reloadRows(at: modificationsIndexPath, with: .automatic)
                    self.tableView.endUpdates()
                }
            case .error(let error):
                print("\(error)")
            }
        }
    }
}
