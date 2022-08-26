//
//  Label.swift
//  Bunker
//
//  Created by Danila Kokin on 15.05.2022.
//

import UIKit

extension UILabel {
    
    func setCustomAttributedText(string: String, font: UIFont, _ lineHeightMultiplicator: CGFloat = 1.0) {
        let attributedString = NSMutableAttributedString(string: string)
        self.numberOfLines = 0
        self.font = font
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = lineHeightMultiplicator
//        let baselineOffset = 0
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
//        attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: baselineOffset, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
    
}
