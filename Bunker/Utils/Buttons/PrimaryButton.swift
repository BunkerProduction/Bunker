//
//  YellowButton.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

final class PrimaryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 12
        self.setTitleColor(.black, for: .normal)
        self.setHeight(to: 48)
        self.setWidth(to: ScreenSize.Width-48)
        self.titleLabel?.font = .customFont.body
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Main.Primary.colorFor(theme)
        self.layer.applyFigmaShadow(color: .Main.Shadow.colorFor(theme) ?? .black)
        self.setTitleColor(.Main.onPrimary.colorFor(theme), for: .normal)
    }
}
