import UIKit
import RealmSwift

// MARK: - AllFriendsController for friends
class AllFriendsController: UITableViewController {
    
    private let friendsVK = UserVKService()
    var friend: [UserVKArray] = []
    let realm = RealmCacheService()
    private var friendResponse: Results<UserVKArray>? {
        realm.read(UserVKArray.self)
    }
    private var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNotificationToken()
        loadFriendDataRealm()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friend.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllFriendsCell", for: indexPath) as? AllFriendsCell else {
            preconditionFailure("Failed to create a cell")
        }
        let friends = friend[indexPath.row]
        
        cell.labelAllFriendsCell.text = friends.firstName
        cell.secondLabelAllFriendsCell.text = friends.lastName
        cell.imageAllFriendsCell.loadImage(with: friends.photo)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is FriendsPhotosController{
            guard let friendsPhotosVC = segue.destination as? FriendsPhotosController else { return }
            guard
                let indexPathSection = tableView.indexPathForSelectedRow?.section,
                let indexPathRow = tableView.indexPathForSelectedRow?.row
            else {
                return
            }
            let section = friend[indexPathRow]
            friendsPhotosVC.friendId = String(section.id)
        }
    }
    
    func loadFriendData() {
        do {
            let realm = try Realm()
            let userVKArray = realm.objects(UserVKArray.self)
            self.friend = Array(userVKArray)
        } catch {
            print(error)
        }
    }
    
    func loadFriendDataRealm() {
        friendsVK.friendAdd { [weak self] friend in
            self?.loadFriendData()
            self?.tableView?.reloadData()
        }
    }
    
    func createNotificationToken() {
        notificationToken = friendResponse?.observe { [ weak self ] result in
            guard let self = self else { return }
            switch result {
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
