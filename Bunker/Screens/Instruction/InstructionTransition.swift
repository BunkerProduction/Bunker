//
//  InstructionTransition.swift
//  Bunker
//
//  Created by Danila Kokin on 10.10.2022.
//

import UIKit

class PopTransitionManager: NSObject {
    private let theme = UserSettings.shared.appearance
    private let animationDuration: Double
    private var animationType: AnimationType
    enum AnimationType {
        case present
        case dismiss
    }

    init(animationDuration: Double = 1, _ animationType: AnimationType = .present) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
}

extension PopTransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
