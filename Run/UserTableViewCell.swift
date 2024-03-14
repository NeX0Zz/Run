import UIKit

class UserTableViewCell: UITableViewCell {
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var kmLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var kcalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var rightSideLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented" )
    }
    
    func configCell(with user: User){
        
        kcalLabel.text = user.kcal
        dateLabel.text = user.date
        rightSideLabel.text = user.steps
        kmLabel.text = user.kilo
        
    }
    
    func setupLayout(){
                
        let mainStackView = UIStackView(arrangedSubviews: [dateLabel, kmLabel])
        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStackView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(kmLabel)
        contentView.addSubview(rightSideLabel)
        contentView.addSubview(kcalLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            
            kmLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            kmLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            
            kcalLabel.leadingAnchor.constraint(equalTo: kmLabel.trailingAnchor,constant: 10),
            kcalLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            
            rightSideLabel.leadingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            rightSideLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            rightSideLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
    }
}
extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
