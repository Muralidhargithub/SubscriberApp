import UIKit

class CustomTableViewCell: UITableViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(label)
        contentView.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with article: SubscriberDetails, imageLoader: @escaping (URL, @escaping (UIImage?) -> Void) -> Void) {
        let text = """
        ID: \(article.id ?? 0)
        Email: \(article.email ?? "")
        FirstName: \(article.first_name ?? "")
        LastName: \(article.last_name ?? "")
        """
        label.text = text
        avatarImageView.image = UIImage(named: "placeholder") // Placeholder
        
        if let avatarURL = URL(string: article.avatar ?? "") {
            imageLoader(avatarURL) { [weak self] image in
                DispatchQueue.main.async {
                    self?.avatarImageView.image = image
                }
            }
        }
    }
}
