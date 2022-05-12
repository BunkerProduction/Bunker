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
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        addSubview(imageView)
        imageView.pin(to: self)
    }
    
    public func configure(_ iconName: AppIcon) {
        self.imageView.image = UIImage(named: iconName.rawValue)
        self.imageView.contentMode = .scaleAspectFit
    }
}
