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
    private let textView = UITextView()
    private let buyButton = UIButton()
    
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
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textView, buyButton])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        
        self.contentView.addSubview(stackView)
        stackView.pin(to: self.contentView, [.left: 16, .right: 16, .top: 16, .bottom: 16])
    }
    
    public func configure(_ premium: Bool) {
        if(premium) {
            titleLabel.text = "Премиум Версия"
            textView.text = "— 18 аппокалипсисов \n — новые характеристики \n — увеличенные комнаты \n — 4 цветовые темы \n— выбор сложности \n 159₽"
            buyButton.isHidden = false
            self.backgroundColor = .Primary.primary
        } else {
            titleLabel.text = "Базовая Версия"
            textView.text = "— 5 аппокалипсисов \n — игры до 12 человек \n — карты особых условий \n— темная тема"
            buyButton.isHidden = true
            self.backgroundColor = .Background.accent
        }
    }
}
