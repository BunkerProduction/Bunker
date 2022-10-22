//
//  MainWindow.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 22.10.2022.
//

import UIKit


final class MainWindow: UIWindow {
    public let debugView = DebagView()

    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)

        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didAddSubview(_ subview: UIView) {
        self.bringSubviewToFront(debugView)
        debugView.frame = CGRect(x: 50, y: 250, width: 50, height: 50)
    }

    private func setup() {
        addSubview(debugView)
        debugView.frame = CGRect(x: 50, y: 150, width: 50, height: 50)
        let panG = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        debugView.addGestureRecognizer(panG)
    }

    @objc private func draggedView(_ sender: UIPanGestureRecognizer) {
        DispatchQueue.main.async {
            let translation = sender.translation(in: self)
            var newX = self.debugView.center.x + translation.x
            let newY = self.debugView.center.y + translation.y
            guard (newX > -10 && newX + 10 < ScreenSize.Width) && (newY > 60 && newY < ScreenSize.Height) else {
                return
            }

            if sender.state == .ended {
                if newX < ScreenSize.Width / 2 {
                    newX = -10
                } else {
                    newX = ScreenSize.Width + 10
                }

                UIView.animate(withDuration: 0.2) {
                    self.debugView.center = CGPoint(
                        x: newX,
                        y: newY
                    )
                    sender.setTranslation(CGPoint.zero, in: self)
                }
            } else {
                self.debugView.center = CGPoint(
                    x: newX,
                    y: newY
                )
                sender.setTranslation(CGPoint.zero, in: self)
            }
        }
    }
}
