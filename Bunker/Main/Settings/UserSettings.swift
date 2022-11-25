//
//  SettingsController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//
import Foundation
import UIKit

// MARK: - Settings Manager
final class UserSettings {
    enum CodingKeys {
        static let username = "BunkerUsername"
        static let sound = "SoundIsOn"
        static let appearence = "Appearence"
        static let language = "Language"
        static let appIcon = "AppIcon"
        static let isPremiumActive = "PremiumStatus"
        static let ownedProducts = "OwnedProducts"
    }
    
    static private let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    static let shared = UserSettings()
    static let applicationVersion: String = "1.0.1"

    private let storage = UserDefaults.standard

    private(set) var ownedProducts: [Product] = []

    public var isPremiumBought: Bool {
        ownedProducts.contains(where: { $0 == Product.premium })
    }

    public var isPremium: Bool = false {
        didSet {
            storage.set(isPremium, forKey: CodingKeys.isPremiumActive)
        }
    }
    
    public var username: String? {
        didSet {
            storage.set(username, forKey: CodingKeys.username)
        }
    }
    
    public var language: Language = .ru {
        didSet {
            storage.set(language.rawValue, forKey: CodingKeys.language)
        }
    }
    
    public var volume: Sound = .on {
        didSet {
            storage.set(volume.rawValue, forKey: CodingKeys.sound)
        }
    }
                
    public var appearance: Appearence = .light {
        didSet {
            setTheme()
            storage.set(appearance.rawValue, forKey: CodingKeys.appearence)
        }
    }
    
    public var appIcon: AppIcon = .light {
        didSet {
            AppIcon.applyAppIcon(icon: appIcon)
            storage.set(appIcon.rawValue, forKey: CodingKeys.appIcon)
        }
    }
    
    init() {
        if let products = storage.object(forKey: CodingKeys.ownedProducts) as? [String] {
            self.ownedProducts = products.map { Product(rawValue: $0)! }
        }

        self.username = storage.object(forKey: CodingKeys.username) as? String
        if let sound = storage.object(forKey: CodingKeys.sound) as? String {
            self.volume = Sound(rawValue: sound) ?? .off
        }
        if let theme = storage.object(forKey: CodingKeys.appearence) as? String {
            self.appearance = Appearence(rawValue: theme) ?? .system
            self.setTheme()
        }
        if let langauge = storage.object(forKey: CodingKeys.language) as? String {
            self.language = Language(rawValue: langauge) ?? .ru
        }
        if let icon = storage.object(forKey: CodingKeys.appIcon) as? String {
            self.appIcon = AppIcon(rawValue: icon) ?? .light
        }
    }
    
    private func setTheme() {
        switch appearance {
        case .light:
            Self.sceneDelegate.window?.overrideUserInterfaceStyle = .light
        case .system:
            Self.sceneDelegate.window?.overrideUserInterfaceStyle = .unspecified
        default:
            Self.sceneDelegate.window?.overrideUserInterfaceStyle = .dark
        }
    }
    
    public func setOption(_ option: SettingsOption) -> SettingsOption? {
        if let lang = option as? Language {
            self.language = lang
            return self.language
        } else if let sound = option as? Sound {
            self.volume = sound
            return self.volume
        } else if let theme = option as? Appearence {
            self.appearance = theme
            return self.appearance
        }
        return nil
    }

    public func saveProduct(product: Product) {
        self.ownedProducts.append(product)
        storage.set(self.ownedProducts.map { $0.rawValue}, forKey: CodingKeys.ownedProducts)
    }
}
