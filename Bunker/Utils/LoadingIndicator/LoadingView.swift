//
//  LoadingView.swift
//  Bunker
//
//  Created by Danila Kokin on 27.08.2022.
//

import UIKit

class LoadingView: UIView {
    public var color: UIColor
    private var lineWidth: CGFloat
    private let duration = 1.0

    private lazy var containerView = UIView()
    private lazy var curveLayer = CAShapeLayer()
    private weak var displayLink: CADisplayLink?

    var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                startDisplayLink()
            } else {
                stopDisplayLink()
            }
        }
    }

    // MARK: - Init
    init(frame: CGRect, color: UIColor, lineWidth: CGFloat) {
        self.color = color
        self.lineWidth = lineWidth

        super.init(frame: frame)
    }

    convenience init(color: UIColor, lineWidth: CGFloat) {
        self.init(frame: .zero, color: color, lineWidth: lineWidth)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - UI Setup
    private func setupView() {
        self.backgroundColor = .clear

        setupContainerView()
        setupCurveLayer()
    }

    private func setupContainerView() {
        self.addSubview(containerView)
        containerView.pin(to: self)
    }

    private func setupCurveLayer() {
        curveLayer.lineCap = .round
        curveLayer.strokeColor = color.cgColor
        curveLayer.lineWidth = lineWidth
        curveLayer.fillColor = UIColor.clear.cgColor

        containerView.layer.addSublayer(curveLayer)
    }

    // MARK: - Animation
    private func animateCurve(center: CGPoint, startAngle: CGFloat) -> CGPath {
        return UIBezierPath(
            arcCenter: center,
            radius: containerView.frame.midX,
            startAngle: startAngle,
            endAngle: startAngle + .pi,
            clockwise: true
        ).cgPath
    }
}

extension LoadingView {
    func startDisplayLink() {
        stopDisplayLink()

        let displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink(_:)))
        displayLink.add(to: .main, forMode: .default)
        self.displayLink = displayLink
    }

    func stopDisplayLink() {
        displayLink?.invalidate()
    }

    @objc func handleDisplayLink(_ displayLink: CADisplayLink) {
        let percent = CGFloat(displayLink.timestamp).truncatingRemainder(dividingBy: duration) / duration
        let center = self.bounds.center
        let angle = percent * .pi * 2
        curveLayer.path = animateCurve(center: center, startAngle: angle)
    }
}
