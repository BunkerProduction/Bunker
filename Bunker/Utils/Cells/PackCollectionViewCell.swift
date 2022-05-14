//
//  PackCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 14.05.2022.
//

import UIKit

class PackCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PackCollectionViewCell"
    
    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var borderColorNormal: CGColor?
    
    override var isSelected: Bool {
        didSet {
            if(isSelected) {
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
                    self.layer.borderWidth = 2
                    self.layer.borderColor = UIColor.Main.Primary.colorFor(UserSettings.shared.appearance)?.cgColor
                }) {_ in self.transform = CGAffineTransform.identity}
            } else {
                self.layer.borderColor = borderColorNormal ?? UIColor.systemGray5.cgColor
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
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        titleLabel.font = .customFont.body
        descriptionLabel.font = .customFont.body
        iconLabel.font = .customFont.icon
        self.layer.cornerRadius = 12
        
        let stackView = UIStackView(arrangedSubviews: [iconLabel, titleLabel, descriptionLabel])
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.axis = .vertical
        
        self.addSubview(stackView)
        
        stackView.pin(to: self, [.left: 12, .right: 12, .bottom: 12, .top: 12])
    }
    
    // MARK: - Configure
    public func configure(_ pack: Catastrophe) {
        iconLabel.text = pack.icon
        titleLabel.text = pack.name
        descriptionLabel.text = pack.shortDescription
    }
    
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .BackGround.Accent.colorFor(theme)
        titleLabel.textColor = .TextAndIcons.Primary.colorFor(theme)
        descriptionLabel.textColor = .TextAndIcons.Primary.colorFor(theme)
    }
}
