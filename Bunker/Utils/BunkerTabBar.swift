//
//  BunkerTabBar.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.05.2022.
//

import Foundation
import UIKit

final class BunkerTabBar: UIControl {
    private let firstTabButton = UIButton()
    private let secondTabButton = UIButton()
    private let thirdTabButton = UIButton()
    private(set) var chosenTab: Int = 0
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    private func setupView() {
        self.layer.cornerRadius = 28
        
        firstTabButton.setImage(UIImage(named: "earthIcon"), for: .normal)
        firstTabButton.tag = 0
        firstTabButton.addTarget(self, action: #selector(tabChanged(_:)), for: .touchUpInside)
        secondTabButton.setImage(UIImage(named: "statsIcon"), for: .normal)
        secondTabButton.tag = 1
        secondTabButton.addTarget(self, action: #selector(tabChanged(_:)), for: .touchUpInside)
        thirdTabButton.setImage(UIImage(named: "profileIcon"), for: .normal)
        thirdTabButton.tag = 2
        thirdTabButton.addTarget(self, action: #selector(tabChanged(_:)), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [firstTabButton, secondTabButton, thirdTabButton])
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .horizontal
        
        self.addSubview(stackView)
        stackView.pin(to: self)
        stackView.setHeight(to: 56)

        changeTabOpacity()
    }

    private func changeTabOpacity() {
        for tab in [firstTabButton, secondTabButton, thirdTabButton] {
            if tab.tag == self.chosenTab {
                tab.alpha = 1
            }
            else {
                tab.alpha = 0.5
            }
        }
    }
    
    // MARK: - Interactions
    @objc
    private func tabChanged(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred(intensity: 0.5)
        
        self.chosenTab = sender.tag
        changeTabOpacity()
        sendActions(for: .valueChanged)
    }
    
    // MARK: - Theme setup
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Main.Primary.colorFor(theme)
        self.layer.applyFigmaShadow(color: .Main.Shadow.colorFor(theme) ?? .clear)
        firstTabButton.imageView?.tintColor = UIColor.Main.onPrimary.colorFor(theme)
        secondTabButton.imageView?.tintColor = UIColor.Main.onPrimary.colorFor(theme)
        thirdTabButton.imageView?.tintColor = UIColor.Main.onPrimary.colorFor(theme)
    }
}
