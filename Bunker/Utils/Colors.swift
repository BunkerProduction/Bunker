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

extension UIColor {
    public convenience init?(hex: String, opacity: CGFloat) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = opacity

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
