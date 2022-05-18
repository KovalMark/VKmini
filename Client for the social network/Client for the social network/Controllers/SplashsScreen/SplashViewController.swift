import UIKit

// MARK: - SplashViewController for animation
class SplashViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateSplash()
    }
    
    func animateSplash() {
        
        UIView.animate(withDuration: 2,
                       delay: 2,
                       options: [.curveEaseInOut, .autoreverse]) {
            self.logoImageView.alpha = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(2.5)), execute: {
            self.performSegue(withIdentifier: "Stop animation", sender: nil)
        })
    }
}



