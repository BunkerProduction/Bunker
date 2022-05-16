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
//        titleLabel.backgroundColor = .green //delete after bugfix
        descriptionLabel.font = .customFont.footnote
//        descriptionLabel.backgroundColor = .red //delete after bugfix
        iconLabel.font = .customFont.icon
//        iconLabel.backgroundColor = .black //delete after bugfix
        self.layer.cornerRadius = 12
        
        let stackView = UIStackView(arrangedSubviews: [iconLabel, titleLabel, descriptionLabel])
//        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 8
        
        self.addSubview(stackView)
        
        stackView.pin(to: self, [.left: 16, .right: 16, .bottom: 16, .top: 16])
    }
    
    // MARK: - Configure
    public func configure(_ pack: Catastrophe) {
        iconLabel.setCustomAttributedText(string: pack.icon, fontSize: 20, 1)
        titleLabel.text = pack.name
        descriptionLabel.setCustomAttributedText(string: pack.shortDescription, fontSize: 14, 1.25)
        //надо заставить стеквью пересчитать дистрибьюшн
    }
    
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
        titleLabel.textColor = .TextAndIcons.Primary.colorFor(theme)
        descriptionLabel.textColor = .TextAndIcons.Secondary.colorFor(theme)
    }
}
