//
//  LoadingView.swift
//  Bunker
//
//  Created by Danila Kokin on 27.08.2022.
//

import UIKit

class LoadingView: UIView {
    var color: UIColor {
        didSet {
            shapeLayer.strokeColor = color.cgColor
        }
    }
    let lineWidth: CGFloat

    private lazy var shapeLayer: LoadingShapeLayer = {
        return LoadingShapeLayer(strokeColor: color, lineWidth: lineWidth)
    }()

    var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                self.animateStroke()
                self.animateRotation()
            } else {
                self.shapeLayer.removeFromSuperlayer()
                self.layer.removeAllAnimations()
            }
        }
    }

    // MARK: - Init
    init(frame: CGRect, color: UIColor, lineWidth: CGFloat) {
        self.color = color
        self.lineWidth = lineWidth

        super.init(frame: frame)

        self.backgroundColor = .clear
    }

    convenience init(color: UIColor, lineWidth: CGFloat) {
        self.init(frame: .zero, color: color, lineWidth: lineWidth)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.frame.width / 2
        let path = UIBezierPath(ovalIn:
                                    CGRect(
                                        x: 0,
                                        y: 0,
                                        width: self.bounds.width,
                                        height: self.bounds.width
                                    )
        )
        shapeLayer.path = path.cgPath
    }

    // MARK: - Animations
    func animateStroke() {
        let startAnimation = StrokeAnimation(
            type: .start,
            beginTime: 0.25,
            fromValue: 0.0,
            toValue: 1.0,
            duration: 0.75
        )
        let endAnimation = StrokeAnimation(
            type: .end,
            fromValue: 0.0,
            toValue: 1.0,
            duration: 0.75
        )

        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1
        strokeAnimationGroup.repeatDuration = .infinity
        strokeAnimationGroup.animations = [startAnimation, endAnimation]

        shapeLayer.add(strokeAnimationGroup, forKey: nil)
        self.layer.addSublayer(shapeLayer)
    }

    func animateRotation() {
        let rotationAnimation = RotationAnimation(
            direction: .z,
            fromValue: 0,
            toValue: CGFloat.pi * 2,
            duration: 2,
            repeatCount: .greatestFiniteMagnitude
        )

        self.layer.add(rotationAnimation, forKey: nil)
    }
}
