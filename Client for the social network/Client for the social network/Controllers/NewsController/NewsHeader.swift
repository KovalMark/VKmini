import UIKit

// MARK: HeaderNews
class NewsHeader: UITableViewHeaderFooterView {
    
    static let identifier: String = "HeaderNews"
    
    // MARK: Views
    private let newsImageView: UIImageView = {
        let newsImageView = UIImageView()
        
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.layer.cornerRadius = 50
        newsImageView.layer.masksToBounds = true
        newsImageView.layer.borderWidth = 2
        newsImageView.layer.borderColor = #colorLiteral(red: 1, green: 0.9959130883, blue: 1, alpha: 1)
        
        return newsImageView
    }()
    
    private let shadowImageView: UIView = {
        let shadowImageView = UIView()
        
        shadowImageView.translatesAutoresizingMaskIntoConstraints = false
        shadowImageView.layer.backgroundColor = #colorLiteral(red: 1, green: 0.9959130883, blue: 1, alpha: 1)
        shadowImageView.layer.cornerRadius = 50
        shadowImageView.layer.shadowColor = #colorLiteral(red: 1, green: 0.9959130883, blue: 1, alpha: 1)
        shadowImageView.layer.shadowOffset = .zero
        shadowImageView.layer.shadowRadius = 5
        shadowImageView.layer.shadowOpacity = 0.5
        shadowImageView.layer.masksToBounds = false
        
        return shadowImageView
    }()
    
    private let newsTextLabel: UILabel = {
        let newsTextLabel = UILabel()
        
        newsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTextLabel.textColor = #colorLiteral(red: 1, green: 0.9959130883, blue: 1, alpha: 1)
        
        return newsTextLabel
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(avatarImage: String?, nameOwner: String?) {
        newsTextLabel.text = nameOwner
        if let url = avatarImage {
            newsImageView.loadImageCache(url)
        }
    }
    
    // MARK: Setup constraint
    private func setConstraints() {
        contentView.addSubview(shadowImageView)
        contentView.addSubview(newsTextLabel)
        contentView.addSubview(newsImageView)
        
        let topConstraint = newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        
        NSLayoutConstraint.activate([
            topConstraint,
            shadowImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            shadowImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            shadowImageView.heightAnchor.constraint(equalToConstant: 100),
            shadowImageView.widthAnchor.constraint(equalToConstant: 100),
            
            newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            newsImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            newsImageView.heightAnchor.constraint(equalToConstant: 100),
            newsImageView.widthAnchor.constraint(equalToConstant: 100),
            
            newsTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            newsTextLabel.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 16),
            newsTextLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
        ])
        topConstraint.priority = .init(999)
    }
}

