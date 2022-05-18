import UIKit

class FriendsPhotosCell: UICollectionViewCell {
    
    @IBOutlet weak var friendsPhotos: UIImageView!
    
    @IBOutlet var likeControl: LikeControl!
    
    @IBOutlet var container: UIView!
    
    override func awakeFromNib() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hadleTap))
        tap.numberOfTapsRequired = 2
        container.addGestureRecognizer(tap)
    }
    
    @objc func hadleTap(_ :UITapGestureRecognizer) {
        likeControl.islike.toggle()
        
        if likeControl.islike {
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
