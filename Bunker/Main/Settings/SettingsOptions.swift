//
//  SettingsOptions.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.05.2022.
//

import Foundation
import CoreImage
import UIKit

// MARK: - Option Protocol
protocol SettingsOption {
    func associatedIcon() -> String
    var allCases: [Self] { get }
    var optionType: String { get }
    var optionName: String { get }
}

// MARK: - Language
public enum Language: String, SettingsOption, CaseIterable {
    case ru = "Russian"
    case eng = "English"
    case zhi = "Chinese"
    
    var optionType: String {
        return "Language"
    }
    
    var optionName: String {
        return self.rawValue
    }
    
    var allCases: [Language] {
        return Self.allCases
    }
    
    func associatedIcon() -> String {
        switch self {
        case .ru:
            return "🇷🇺"
        case .eng:
            return "🇬🇧"
        case .zhi:
            return "🇨🇳"
        }
    }
}

// MARK: - Appearence
public enum Appearence: String, SettingsOption, CaseIterable {
    case light = "Light", dark = "Dark", system = "System", toxic = "Toxic", poisonous = "Poisonous", mono = "Mono", alian = "Alian", holo = "Holo"
    
    var optionType: String {
        return "Theme"
    }
    
    var optionName: String {
        return self.rawValue
    }
    
    var allCases: [Appearence] {
        return Self.allCases
    }
    
    func associatedIcon() -> String {
        switch self {
        case .light:
            return "🌕"
        case .dark:
            return "🌑"
        case .system:
            return "🌗"
        case .toxic:
            return "🧪"
        case .poisonous:
            return "🧫"
        case .mono:
            return "🔳"
        case .alian:
            return "🛸"
        case .holo:
            return "🪩"
        }
    }
}

// MARK: - Sound
public enum Sound: String, SettingsOption, CaseIterable {
    case on = "On", off = "Off"
    
    var optionType: String {
        return "Sound"
    }
    
    var optionName: String {
        return self.rawValue
    }
    
    var allCases: [Sound] {
        return Self.allCases
    }
    
    func associatedIcon() -> String {
        switch self {
        case .on:
            return "🔊"
        case .off:
            return "🔇"
        }
    }
}

// MARK: - App Icon
public enum AppIcon: String, CaseIterable {
    case light = "LightPreview.png"
    case dark = "DarkPreview.png"
    case holo = "HoloPreview.png"
    case alian = "AlianPreview.png"
    case mono = "MonoPreview.png"
    case toxic = "ToxicPreview.png"
    
    
    static func applyAppIcon(icon: AppIcon) {
        let app = UIApplication.shared
        
        switch icon {
        case .light:
            app.setAlternateIconName(nil)
        case .dark:
            app.setAlternateIconName("darkIcon")
        case .holo:
            app.setAlternateIconName("holoIcon")
        case .alian:
            app.setAlternateIconName("alianIcon")
        case .mono:
            app.setAlternateIconName("monoIcon")
        case .toxic:
            app.setAlternateIconName("toxicIcon")
        }
    }
}
