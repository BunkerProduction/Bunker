//
//  VersionCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.05.2022.
//

import UIKit

final class VersionCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "VersionCollectionViewCell"
    
    private let titleLabel = UILabel()
    private let textLabel = UILabel()
    private let priceLabel = UILabel()
    private let buyButton = UIButton()
    private var isPremium: Bool = false
    
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
        self.layer.cornerCurve = .continuous
        buyButton.setTitle("Buy", for: .normal)
        buyButton.backgroundColor = .red
        buyButton.titleLabel?.font = .customFont.body
        buyButton.layer.cornerRadius = 8
        buyButton.setTitleColor(.black, for: .normal)
        buyButton.setHeight(to: 36)
        
        titleLabel.textAlignment = .left
        titleLabel.font = .customFont.body
        
        textLabel.textAlignment = .left
        textLabel.font = .customFont.footnote
//        textLabel.backgroundColor = .clear
        textLabel.numberOfLines = 0
        
        priceLabel.textAlignment = .left
        priceLabel.font = .customFont.body
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textLabel, priceLabel, buyButton])
        stackView.distribution = .equalSpacing
//        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 24
        
        self.contentView.addSubview(stackView)
        stackView.pin(to: self.contentView, [.left: 16, .right: 16, .top: 16, .bottom: 16])
    }
    
    public func configure(_ premium: Bool) {
        self.isPremium = premium
        if(isPremium) {
            titleLabel.text = "Премиум Версия"
            let text = "— 18 аппокалипсисов\n— новые характеристики\n— увеличенные комнаты\n— 4 цветовые темы\n— выбор сложности"
            textLabel.setCustomAttributedText(
                string: text,
                font: .customFont.footnote ?? .systemFont(ofSize: 0),
                1.25
            )
            priceLabel.text = "159₽"
            buyButton.isHidden = false
            self.backgroundColor = .clear
        } else {
            titleLabel.text = "Базовая Версия"
            let text = "— 5 аппокалипсисов \n— игры до 12 человек \n— карты особых условий \n— темная тема"
            textLabel.setCustomAttributedText(
                string: text,
                font: .customFont.footnote ?? .systemFont(ofSize: 0),
                1.25
            )
            priceLabel.text = ""
            buyButton.isHidden = true
            self.backgroundColor = .clear
        }
    }
    
    public func setTheme(_ theme: Appearence) {
        if isPremium {
            self.layer.applyFigmaShadow(color: .Main.Shadow.colorFor(theme) ?? .clear)
            self.backgroundColor = .Main.Primary.colorFor(theme)
        } else {
            self.layer.applyFigmaShadow(color: .clear)
            self.backgroundColor = .Background.Accent.colorFor(theme)
        }
        buyButton.backgroundColor = .Background.LayerTwo.colorFor(theme)
        buyButton.setTitleColor(.TextAndIcons.Primary.colorFor(theme), for: .normal)
        titleLabel.textColor = isPremium ? .Main.onPrimary.colorFor(theme) : .TextAndIcons.Primary.colorFor(theme)
        textLabel.textColor = isPremium ? .Main.onPrimary.colorFor(theme) : .TextAndIcons.Secondary.colorFor(theme)
        priceLabel.textColor = isPremium ? .Main.onPrimary.colorFor(theme) : .TextAndIcons.Primary.colorFor(theme)
    }
}

// MARK: - Transformation
extension VersionCollectionViewCell {
    public func transformToLarge() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.contentView.alpha = 1
        }
    }
    
    public func transformBack() {
        UIView.animate(withDuration: 0.1) {
            self.contentView.alpha = 0.5
            self.transform = CGAffineTransform.identity
        }
    }
}
