import UIKit

class AllFriendsView: UIView {
    
    @IBOutlet var shadowView: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    
    var shadowColor = #colorLiteral(red: 1, green: 0.9959130883, blue: 1, alpha: 1)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 15
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        avatarImageView.layer.cornerRadius = bounds.height/2
        shadowView.layer.cornerRadius = bounds.height/2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIImageView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction]) {
            self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        } completion: { completed in
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIImageView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction]) {
            self.transform = .identity
        } completion: { completed in
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        UIImageView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction]) {
            self.transform = .identity
        } completion: { completed in
        }
    }
}
