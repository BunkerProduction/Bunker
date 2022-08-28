//
//  LoadingShapeLayer.swift
//  Bunker
//
//  Created by Danila Kokin on 27.08.2022.
//

import UIKit

class LoadingShapeLayer: CAShapeLayer {
    public init(strokeColor: UIColor, lineWidth: CGFloat) {
        super.init()

        self.strokeColor = strokeColor.cgColor
        self.lineWidth = lineWidth
        self.fillColor = UIColor.clear.cgColor
        self.lineCap = .round
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
