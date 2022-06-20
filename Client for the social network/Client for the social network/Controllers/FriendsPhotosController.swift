import UIKit

private let reuseIdentifier = "Cell"

// MARK: - FriendsPhotosController for photo
class FriendsPhotosController: UICollectionViewController {
    
    private let photosVK = PhotoVKService()
    var photo: [PhotoVKArray] = []
    var friendId: String = ""
    var storedImages: [String] = []
    private var imageService: ImageService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotoDataRealm()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storedImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsPhotosCell",for: indexPath) as? FriendsPhotosCell
        else {
            preconditionFailure("Нет друзей")
        }
        cell.friendsPhotos.loadImageCache(storedImages[indexPath.item])
        
        return cell
    }
    
    func loadPhotoDataRealm() {
        photosVK.photoAdd(userID: friendId) { [weak self] photo in
            if let imagesLinks = self?.sortImage(type: "m", array: photo) {
                self?.storedImages = imagesLinks
            }
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
                
            }
        }
    }
    
    func sortImage(type: String, array: [PhotoVKArray]) -> [String] {
        var links: [String] = []
        
        for model in array {
            for size in model.sizes {
                if size.type == type {
                    links.append(size.url)
                }
            }
        }
        return links
    }
}
