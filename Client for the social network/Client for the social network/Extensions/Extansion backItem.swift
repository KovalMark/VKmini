import UIKit

// MARK: - Delete 'back' for BackItem
extension UITableViewController {
    
    open override func viewDidLoad() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
    }
}

extension UICollectionViewController {
    
    open override func viewDidLoad() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
    }
}
