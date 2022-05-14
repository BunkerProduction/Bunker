//
//  BunkerTextField.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

final class BunkerTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.layer.cornerRadius = 12
        self.setLeftPaddingPoints(16)
        self.setHeight(to: 48)
    }
    
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
        self.tintColor = .Main.Primary.colorFor(theme)
        self.font = .customFont.body
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? " ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextAndIcons.Tertiary.colorFor(theme) ?? .white])
        self.textColor = .TextAndIcons.Primary.colorFor(theme)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
