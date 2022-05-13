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
        self.layer.applyFigmaShadow()
        self.backgroundColor = .Main.Primary.colorFor(.poisonous)
        self.setTitleColor(.black, for: .normal)
        self.setHeight(to: 48)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}