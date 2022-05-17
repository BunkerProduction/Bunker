//
//  Baige.swift
//  Bunker
//
//  Created by Danila Kokin on 17.05.2022.
//

import Foundation
import UIKit

final class BaigeLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 12
        self.text = "ПРЕМИУМ"
        self.font = .customFont.baige
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.textAlignment = .center
        
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.LayerOne.colorFor(theme)
        self.layer.borderColor = UIColor.Outline.Strong.colorFor(theme)?.cgColor
        self.textColor = UIColor.Outline.Strong.colorFor(theme)
    }
}
