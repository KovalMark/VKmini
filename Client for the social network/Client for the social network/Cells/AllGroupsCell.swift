import UIKit

class AllGroupsCell: UITableViewCell {
    
    @IBOutlet weak var Shadow: UIView!
    
    @IBOutlet weak var labelAllGroups: UILabel!
    
    @IBOutlet weak var ImageAllGroups: UIImageView!
    
    var shadowColor = #colorLiteral(red: 1, green: 0.9959130883, blue: 1, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Shadow.layer.shadowColor = shadowColor.cgColor
        Shadow.layer.shadowOffset = .zero
        Shadow.layer.shadowRadius = 15
        Shadow.layer.shadowOpacity = 0.4
        Shadow.layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        ImageAllGroups.layer.cornerRadius = bounds.height/2
        Shadow.layer.cornerRadius = bounds.height/2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIImageView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction]) {
            self.ImageAllGroups.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.Shadow.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.labelAllGroups.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { completed in
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIImageView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction]) {
            self.ImageAllGroups.transform = .identity
            self.Shadow.transform = .identity
            self.labelAllGroups.transform = .identity
        } completion: { completed in
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        UIImageView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction]) {
            self.ImageAllGroups.transform = .identity
            self.Shadow.transform = .identity
            self.labelAllGroups.transform = .identity
        } completion: { completed in
        }
    }
}
