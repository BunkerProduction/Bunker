//
//  IconCollectionViewCell.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.05.2022.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "IconCollectionViewCell"
    
    private var iconName: String?
    private let imageView = UIImageView()
    private var borderColorNormal: CGColor?
    
    override var isSelected: Bool {
        didSet {
            if(isSelected) {
              UIView.animate(withDuration: 0.1, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
                  self.layer.borderColor = UIColor.Main.Primary.colorFor(UserSettings.shared.appearance)?.cgColor
            }) {_ in self.transform = CGAffineTransform.identity}
            } else {
                self.layer.borderColor = borderColorNormal ?? UIColor.systemGray5.cgColor
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
        layer.borderWidth = 2
        layer.cornerRadius = 16
        layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        
        addSubview(imageView)
        imageView.pin(to: self, [.left: 6, .right: 6, .top: 6, .bottom: 6])
    }
    
    public func configure(_ iconName: AppIcon) {
        self.imageView.image = UIImage(named: iconName.rawValue)
        self.imageView.contentMode = .scaleAspectFit
    }
    
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.LayerOne.colorFor(theme)
        let borderColor = UIColor.Outline.Strong.colorFor(theme)?.cgColor ?? UIColor.clear.cgColor
        self.layer.borderColor = borderColor
        self.borderColorNormal = borderColor
    }
}
