//
//  SettingsCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.05.2022.
//

import UIKit

class SettingsCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SettingsCollectionViewCell"
    
    private let nameLabel = UILabel()
    private let iconLabel = UILabel()
    
    override var isSelected: Bool {
        didSet {
            if(isSelected) {
              UIView.animate(withDuration: 0.1, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
                    self.layer.borderWidth = 2
                  self.layer.borderColor = UIColor.Main.Primary.colorFor(UserSettings.shared.appearance)?.cgColor
            }) {_ in self.transform = CGAffineTransform.identity}
            } else {
                self.layer.borderWidth = 0
            }
        }
    }
    
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
        self.backgroundColor = .BackGround.Accent.colorFor(UserSettings.shared.appearance)
        
        nameLabel.textAlignment = .left
        iconLabel.textAlignment = .right
        nameLabel.font = .customFont.body
        iconLabel.font = .customFont.icon
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, iconLabel])
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        stackView.axis = .horizontal
        
        self.contentView.addSubview(stackView)
        
        stackView.pin(to: self.contentView, [.left: 12, .right: 12, .top: 16, .bottom: 16])
    }
    
    // MARK: - Interface
    public func configure(_ name: String, _ icon: String) {
        self.nameLabel.text = name
        self.iconLabel.text = icon
    }
    
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .BackGround.Accent.colorFor(theme)
        nameLabel.textColor = .TextAndIcons.Primary.colorFor(theme)
    }
}
