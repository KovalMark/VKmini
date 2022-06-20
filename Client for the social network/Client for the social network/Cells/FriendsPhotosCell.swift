import UIKit

class FriendsPhotosCell: UICollectionViewCell {
    
    @IBOutlet weak var friendsPhotos: UIImageView!
    @IBOutlet var likeControl: LikeControl!
    @IBOutlet var container: UIView!
    
    override func awakeFromNib() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(headTap))
        tap.numberOfTapsRequired = 2
        container.addGestureRecognizer(tap)
    }
    
    @objc func headTap(_ :UITapGestureRecognizer) {
        likeControl.isLike.toggle()
        
        if likeControl.isLike {
            UIView.transition(with: likeControl,
                              duration: 0.3,
                              options: .transitionCurlUp) {
                self.likeControl.likeImage.image = UIImage(named: "fulllike")
            }
        } else {
            UIView.transition(with: likeControl,
                              duration: 0.3,
                              options: .transitionCurlUp) {
                self.likeControl.likeImage.image = UIImage(named: "emptylike")
            }
        }
    }
}
