//
//  Colors.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

public extension UIColor {
    enum Primary {
        static let primary = UIColor(named: "Primary")
    }
    
    enum Background {
        static let accent = UIColor(named: "Accent")
    }
    
    // вариант был но так то херня полная
//    вызывалось так UIColor.Background.accent.colorFor(.light)
//    enum Primary {
//        static let primary = PrimaryColors.self
//    }
//
//    enum Background {
//        static let accent = AccentColors.self
//    }
//
//    struct PrimaryColors {
//        static func colorFor(_ theme: Appearence) -> UIColor? {
//            switch theme {
//            case .light:
//                return UIColor(named: "Primary")
//            case .dark:
//                return UIColor(named: "Primary")
//            case .system:
//                return UIColor(named: "Primary")
//            }
//        }
//    }
//
//    struct AccentColors {
//        static func colorFor(_ theme: Appearence) -> UIColor? {
//            switch theme {
//            case .light:
//                return UIColor(named: "Accent")
//            case .dark:
//                return UIColor(named: "Accent")
//            case .system:
//                return UIColor(named: "Accent")
//            }
//        }
//    }
}
