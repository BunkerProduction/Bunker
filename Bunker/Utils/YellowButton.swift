//
//  YellowButton.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

final class YellowButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 12
        self.layer.applySketchShadow(color: .Primary.primary ?? .yellow, alpha: 0.3, x: 0, y: 8, blur: 16, spread: 0)
        self.backgroundColor = .Primary.primary
        self.setTitleColor(.black, for: .normal)
        self.setHeight(to: 48)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
