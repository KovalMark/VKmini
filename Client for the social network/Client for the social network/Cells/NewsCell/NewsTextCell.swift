import UIKit

// MARK: TextCell
class NewsTextCell: UITableViewCell {
    
    static let identifier: String = "TextCell"
    let container = UILayoutGuide()
    
    // MARK: Views
    private let newsTextLabel: UILabel = {
        let newsTextLabel = UILabel()
        
        newsTextLabel.numberOfLines = 0
        newsTextLabel.textColor = #colorLiteral(red: 1, green: 0.9959130883, blue: 1, alpha: 1)
        newsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return newsTextLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsTextLabel.numberOfLines = 0
        contentView.backgroundColor = #colorLiteral(red: 0.1128253862, green: 0.1178093925, blue: 0.1177227572, alpha: 1)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ text: String?) {
        newsTextLabel.text = text
    }
    
    // MARK: Setup constraint
    private func setConstraints() {
        contentView.addSubview(newsTextLabel)
        contentView.addLayoutGuide(container)
        
        let topConstraint = newsTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        
        NSLayoutConstraint.activate([
            topConstraint,
            newsTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            newsTextLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            newsTextLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            container.leftAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        topConstraint.priority = .init(999)
    }
}

