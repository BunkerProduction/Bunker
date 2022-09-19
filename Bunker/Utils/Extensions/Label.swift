//
//  Label.swift
//  Bunker
//
//  Created by Danila Kokin on 15.05.2022.
//

import UIKit

extension UILabel {
    
    func setCustomAttributedText(string: String, font: UIFont?, _ lineHeightMultiplicator: CGFloat = 1.0) {
        let attributedString = NSMutableAttributedString(string: string)
        self.numberOfLines = 0
        self.font = font
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = lineHeightMultiplicator
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }

    func textHeight() -> Double {
        self.text = "Some String"
        self.sizeToFit()

        return self.frame.height
    }
}
