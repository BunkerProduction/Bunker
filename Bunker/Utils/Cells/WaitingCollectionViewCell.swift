//
//  WaitingCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 16.05.2022.
//

import UIKit

final class WaitingCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "WaitingCollectionViewCell"
    
    private let nameLabel = UILabel()
    private let numberLabel = UILabel()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    private func setupView() {
        self.layer.cornerRadius = 12
        
        nameLabel.textAlignment = .left
        numberLabel.textAlignment = .left
        nameLabel.font = .customFont.body
        numberLabel.font = .customFont.icon
        
        let stackView = UIStackView(arrangedSubviews: [numberLabel, nameLabel])
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        self.contentView.addSubview(stackView)
        
        stackView.pin(to: self.contentView, [.left: 12, .right: 12, .top: 16, .bottom: 16])
    }
    
    public func configure(_ player: User) {
        self.numberLabel.text = "# \(player.orderNumber)"
        var text = player.username
        text += player.isCreator ? " 👑" : ""
        self.nameLabel.text = text
    }
    
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
        nameLabel.textColor = .TextAndIcons.Primary.colorFor(theme)
        numberLabel.textColor = .TextAndIcons.Primary.colorFor(theme)
    }
}
