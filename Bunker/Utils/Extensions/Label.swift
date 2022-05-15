//
//  Label.swift
//  Bunker
//
//  Created by Danila Kokin on 15.05.2022.
//

import UIKit

extension UILabel {
    
    func setCustomAttributedText(string: String, fontSize: CGFloat, _ lineHeightMultiplicator: CGFloat) {
        let attributedString = NSMutableAttributedString(string: string)
        self.numberOfLines = 0
        self.font = .systemFont(ofSize: fontSize)
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = lineHeightMultiplicator
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
    
}
