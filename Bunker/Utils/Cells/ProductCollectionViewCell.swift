//
//  VersionCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.05.2022.
//

import UIKit

final class ProductCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "VersionCollectionViewCell"

    public struct ViewModel {
        let title: String
        let desciption: String
        let price: String?
        let action: (() -> Void)?
    }

    private let titleLabel = UILabel()
    private let textLabel = UILabel()
    private let priceLabel = UILabel()
    private let buyButton = UIButton()

    private var viewModel: ViewModel?
    
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
        buyButton.setTitle("Купить", for: .normal)
        buyButton.backgroundColor = .red
        buyButton.titleLabel?.font = .customFont.body
        buyButton.layer.cornerRadius = 8
        buyButton.layer.cornerCurve = .continuous
        buyButton.setTitleColor(.black, for: .normal)
        buyButton.setHeight(to: 36)
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        
        titleLabel.textAlignment = .left
        titleLabel.font = .customFont.body
        
        textLabel.textAlignment = .left
        textLabel.font = .customFont.footnote
        textLabel.numberOfLines = 0
        
        priceLabel.textAlignment = .left
        priceLabel.font = .customFont.body
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textLabel, priceLabel, buyButton])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 24
        
        self.contentView.addSubview(stackView)
        stackView.pin(to: self.contentView, [.left: 16, .right: 16, .top: 16, .bottom: 16])
    }

    @objc private func buyButtonTapped() {
        viewModel?.action?()
    }
    
    public func configure(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price

        textLabel.setCustomAttributedText(
            string: viewModel.desciption,
            font: .customFont.footnote ?? .systemFont(ofSize: 0),
            1.25
        )

        if viewModel.action == nil {
            buyButton.isHidden = true
        }
    }
    
    public func setTheme(_ theme: Appearence) {
        let isPremium = true
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
extension ProductCollectionViewCell {
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
