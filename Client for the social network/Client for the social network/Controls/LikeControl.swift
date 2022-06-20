import UIKit

class LikeControl: UIControl {
    
    @IBOutlet var likeImage: UIImageView!
    
    var isLike: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeImage.backgroundColor = .clear
    }
}
