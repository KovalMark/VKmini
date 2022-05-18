import UIKit

// MARK: - Image for url
extension UIImageView {
    func loadImage(with url: String, placeHolder: UIImage? = nil) {
        self.image = nil
        
        let imageServerUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let url = URL(string: imageServerUrl) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if error != nil {
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadImage = UIImage(data: data) {
                            self.image = downloadImage
                        }
                    }
                }
            } .resume()
        }
    }
}
