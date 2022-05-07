//
//  BunkerLogo.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

final class BunkerLogo: UIView {
    private let bunkerLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setup() {
        self.backgroundColor = .Primary.primary
        
        bunkerLabel.text = "Бункер"
        bunkerLabel.textAlignment = .center
        bunkerLabel.textColor = .black
        self.addSubview(bunkerLabel)
        
        bunkerLabel.pin(to: self, [.left: 8, .right: 8, .top: 6, .bottom: 6])
        
        self.setHeight(to: 45)
        self.setWidth(to: 120)
    }
}
