//
//  CALayer+Shadow.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

extension CALayer {
    func applyFigmaShadow(
        color: UIColor = .ShadowColors.colorFor(.system) ?? .black,
        alpha: Float = 1,
        x: CGFloat = 0,
        y: CGFloat = 12,
        blur: CGFloat = 24,
        spread: CGFloat = 0
    )
    {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
