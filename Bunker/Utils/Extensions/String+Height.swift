//
//  String+Height.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 14.05.2022.
//

import UIKit

extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
    
    
    func lineHeight(constraintedWidth width: CGFloat, font: UIFont, multiplicator: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        label.setWidth(to: width)
        label.numberOfLines = 0
        label.setCustomAttributedText(
            string: self,
            font: .customFont.footnote ?? .systemFont(ofSize: 0),
            1.25
        )
        label.sizeToFit()
        let height = label.frame.height
        return height
    }
}

extension NSAttributedString {
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
        let leftCopy = NSMutableAttributedString(attributedString: left)
        leftCopy.append(right)
        return leftCopy
    }

    static func + (left: NSAttributedString, right: String) -> NSAttributedString {
        let leftCopy = NSMutableAttributedString(attributedString: left)
        let rightAttr = NSMutableAttributedString(string: right)
        leftCopy.append(rightAttr)
        return leftCopy
    }

    static func + (left: String, right: NSAttributedString) -> NSAttributedString {
        let leftAttr = NSMutableAttributedString(string: left)
        leftAttr.append(right)
        return leftAttr
    }
}

extension NSMutableAttributedString {
    static func += (left: NSMutableAttributedString, right: String) -> NSMutableAttributedString {
        let rightAttr = NSMutableAttributedString(string: right)
        left.append(rightAttr)
        return left
    }

    static func += (left: NSMutableAttributedString, right: NSAttributedString) -> NSMutableAttributedString {
        left.append(right)
        return left
    }
}
