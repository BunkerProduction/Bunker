//
//  VersionCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.05.2022.
//

import UIKit

class VersionCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "VersionCollectionViewCell"
    
    private let titleLabel = UILabel()
    private let textLabel = UILabel()
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
        buyButton.setTitle("Купить", for: .normal)
        buyButton.backgroundColor = .BackGround.LayerOne.colorFor(.light)
        buyButton.layer.cornerRadius = 8
        buyButton.setTitleColor(.black, for: .normal)
        buyButton.setHeight(to: 36)
        
        titleLabel.textAlignment = .left
        textLabel.backgroundColor = .clear
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .justified
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textLabel, buyButton])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 24
        
        self.contentView.addSubview(stackView)
        stackView.pin(to: self.contentView, [.left: 16, .right: 16, .top: 16, .bottom: 16])
    }
    
    public func configure(_ premium: Bool) {
        self.isPremium = premium
        if(isPremium) {
            titleLabel.text = "Премиум Версия"
            textLabel.text = "— 18 аппокалипсисов \n— новые характеристики \n— увеличенные комнаты \n— 4 цветовые темы \n— выбор сложности \n159₽"
            buyButton.isHidden = false
            self.backgroundColor = .Primary.primary
        } else {
            titleLabel.text = "Базовая Версия"
            textLabel.text = "— 5 аппокалипсисов \n— игры до 12 человек \n— карты особых условий \n— темная тема"
            buyButton.isHidden = true
            self.backgroundColor = .Background.accent
        }
    }
    
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = isPremium ? .Main.Primary.colorFor(theme) : .BackGround.Accent.colorFor(theme)
        buyButton.backgroundColor = .BackGround.LayerOne.colorFor(theme)
        buyButton.setTitleColor(.black, for: .normal)
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
