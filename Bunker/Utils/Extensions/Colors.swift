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
//        static let accent = UIColor(named: "Accent")
        static let accent = UIColor(hex: "#f5f5f5", opacity: 1)
    }
    
    // вариант был но так то херня полная
//    вызывалось так UIColor.Background.accent.colorFor(.light)
    
    // MARK: - Colors
    
    enum Main {
        static let Primary = PrimaryColors.self
        static let onPrimary = OnPrimaryColors.self
        static let Warning = WarningColors.self
    }

    enum BackGround {
        static let Accent = AccentColors.self
        static let LayerOne = LayerOneColors.self
        static let LayerTwo = LayerTwoColors.self
    }
    
    enum TextAndIcons {
        static let Primary = PrimaryTextColors.self
        static let Secondary = SecondaryTextColors.self
        static let Tertiary = TertiaryTextColors.self
    }
    
    enum Outline {
        static let Strong = StrongColors.self
        static let Light = LightColors.self
    }
    
    // MARK: - Color Schemes

    struct PrimaryColors {
        static func colorFor(_ theme: Appearence) -> UIColor? {
            switch theme {
            case .light:
                return UIColor(named: "Primary")
            case .dark:
                return UIColor(named: "Primary")
            case .system:
                return UIColor(named: "Primary")
            case .toxic:
                return UIColor(hex: "#B4F21F", opacity: 1)
            case .poisonous:
                return UIColor(hex: "#F21F6B", opacity: 1)
            case .mono:
                return UIColor(hex: "#787878", opacity: 1)
            case .alian:
                return UIColor(hex: "#231FF2", opacity: 1)
            case .holo:
                return UIColor(hex: "#B0DCF5", opacity: 1)
            }
        }
    }
    
    struct OnPrimaryColors {
        static func colorFor(_ theme: Appearence) -> UIColor? {
            switch theme {
            case .light:
                return UIColor(named: "onPrimary")
            case .dark:
                return UIColor(named: "onPrimary")
            case .system:
                return UIColor(named: "onPrimary")
            case .toxic:
                return UIColor(hex: "#000000", opacity: 1)
            case .poisonous:
                return UIColor(hex: "#000000", opacity: 1)
            case .mono:
                return UIColor(hex: "#000000", opacity: 1)
            case .alian:
                return UIColor(hex: "#000000", opacity: 1)
            case .holo:
                return UIColor(hex: "#000000", opacity: 1)
            }
        }
    }
    
    struct WarningColors {
        static func colorFor(_ theme: Appearence) -> UIColor? {
            switch theme {
            case .light:
                return UIColor(named: "Warning")
            case .dark:
                return UIColor(named: "Warning")
            case .system:
                return UIColor(named: "Warning")
            case .toxic:
                return UIColor(hex: "#D95D5D", opacity: 1)
            case .poisonous:
                return UIColor(hex: "#D95D5D", opacity: 1)
            case .mono:
                return UIColor(hex: "#D95D5D", opacity: 1)
            case .alian:
                return UIColor(hex: "#D95D5D", opacity: 1)
            case .holo:
                return UIColor(hex: "#D95D5D", opacity: 1)
            }
        }
    }

    struct AccentColors {
        static func colorFor(_ theme: Appearence) -> UIColor? {
            switch theme {
            case .light:
                return UIColor(named: "Accent")
            case .dark:
                return UIColor(named: "Accent")
            case .system:
                return UIColor(named: "Accent")
            case .toxic:
                return UIColor(hex: "#333333", opacity: 1)
            case .poisonous:
                return UIColor(hex: "#333333", opacity: 1)
            case .mono:
                return UIColor(hex: "#333333", opacity: 1)
            case .alian:
                return UIColor(hex: "#333333", opacity: 1)
            case .holo:
                return UIColor(hex: "#333333", opacity: 1)
            }
        }
    }
    
    struct LayerOneColors {
        static func colorFor(_ theme: Appearence) -> UIColor? {
            switch theme {
            case .light:
                return UIColor(named: "LayerOne")
            case .dark:
                return UIColor(named: "LayerOne")
            case .system:
                return UIColor(named: "LayerOne")
            case .toxic:
                return UIColor(hex: "#121212", opacity: 1)
            case .poisonous:
                return UIColor(hex: "#121212", opacity: 1)
            case .mono:
                return UIColor(hex: "#121212", opacity: 1)
            case .alian:
                return UIColor(hex: "#121212", opacity: 1)
            case .holo:
                return UIColor(hex: "#121212", opacity: 1)
            }
        }
    }
    
    struct LayerTwoColors {
        static func colorFor(_ theme: Appearence) -> UIColor? {
            switch theme {
            case .light:
                return UIColor(named: "LayerTwo")
            case .dark:
                return UIColor(named: "LayerTwo")
            case .system:
                return UIColor(named: "LayerTwo")
            case .toxic:
                return UIColor(hex: "#212121", opacity: 1)
            case .poisonous:
                return UIColor(hex: "#212121", opacity: 1)
            case .mono:
                return UIColor(hex: "#212121", opacity: 1)
            case .alian:
                return UIColor(hex: "#212121", opacity: 1)
            case .holo:
                return UIColor(hex: "#212121", opacity: 1)
            }
        }
    }
    
    struct PrimaryTextColors {
        static func colorFor(_ theme: Appearence) -> UIColor? {
            switch theme {
            case .light:
                return UIColor(named: "PrimaryText")
            case .dark:
                return UIColor(named: "PrimaryText")
            case .system:
                return UIColor(named: "PrimaryText")
            case .toxic:
                return UIColor(hex: "#FFFFFF", opacity: 1)
            case .poisonous:
                return UIColor(hex: "#FFFFFF", opacity: 1)
            case .mono:
                return UIColor(hex: "#FFFFFF", opacity: 1)
            case .alian:
                return UIColor(hex: "#FFFFFF", opacity: 1)
            case .holo:
                return UIColor(hex: "#FFFFFF", opacity: 1)
            }
        }
    }
    
    struct SecondaryTextColors {
        static func colorFor(_ theme: Appearence) -> UIColor? {
            switch theme {
            case .light:
                return UIColor(named: "SecondaryText")
            case .dark:
                return UIColor(named: "SecondaryText")
            case .system:
                return UIColor(named: "SecondaryText")
            case .toxic:
                return UIColor(hex: "#FFFFFF", opacity: 0.7)
            case .poisonous:
                return UIColor(hex: "#FFFFFF", opacity: 0.7)
            case .mono:
                return UIColor(hex: "#FFFFFF", opacity: 0.7)
            case .alian:
                return UIColor(hex: "#FFFFFF", opacity: 0.7)
            case .holo:
                return UIColor(hex: "#FFFFFF", opacity: 0.7)
            }
        }
    }
    
    struct TertiaryTextColors {
        static func colorFor(_ theme: Appearence) -> UIColor? {
            switch theme {
            case .light:
                return UIColor(named: "TertiaryText")
            case .dark:
                return UIColor(named: "TertiaryText")
            case .system:
                return UIColor(named: "TertiaryText")
            case .toxic:
                return UIColor(hex: "#FFFFFF", opacity: 0.4)
            case .poisonous:
                return UIColor(hex: "#FFFFFF", opacity: 0.4)
            case .mono:
                return UIColor(hex: "#FFFFFF", opacity: 0.4)
            case .alian:
                return UIColor(hex: "#FFFFFF", opacity: 0.4)
            case .holo:
                return UIColor(hex: "#FFFFFF", opacity: 0.4)
            }
        }
    }
    
    struct StrongColors {
        static func colorFor(_ theme: Appearence) -> UIColor? {
            switch theme {
            case .light:
                return UIColor(named: "Strong")
            case .dark:
                return UIColor(named: "Strong")
            case .system:
                return UIColor(named: "Strong")
            case .toxic:
                return UIColor(hex: "#FFFFFF", opacity: 0.08)
            case .poisonous:
                return UIColor(hex: "#FFFFFF", opacity: 0.08)
            case .mono:
                return UIColor(hex: "#FFFFFF", opacity: 0.08)
            case .alian:
                return UIColor(hex: "#FFFFFF", opacity: 0.08)
            case .holo:
                return UIColor(hex: "#FFFFFF", opacity: 0.08)
            }
        }
    }
    
    struct LightColors {
        static func colorFor(_ theme: Appearence) -> UIColor? {
            switch theme {
            case .light:
                return UIColor(named: "Light")
            case .dark:
                return UIColor(named: "Light")
            case .system:
                return UIColor(named: "Light")
            case .toxic:
                return UIColor(hex: "#FFFFFF", opacity: 0.04)
            case .poisonous:
                return UIColor(hex: "#FFFFFF", opacity: 0.04)
            case .mono:
                return UIColor(hex: "#FFFFFF", opacity: 0.04)
            case .alian:
                return UIColor(hex: "#FFFFFF", opacity: 0.04)
            case .holo:
                return UIColor(hex: "#FFFFFF", opacity: 0.04)
            }
        }
    }
}

// MARK: - Hex UIColor initializer

extension UIColor {
    public convenience init?(hex: String, opacity: Float) {
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
                    a = CGFloat(opacity)

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
