//
//  SettingsController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import Foundation

protocol SettingsOption {
    func associatedIcon() -> String
    var optionName: String { get }
}

public enum Language: String, SettingsOption {
    case ru,eng,zhi
    
    var optionName: String {
        return "Язык"
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

public enum Appearence: String, SettingsOption {
    case light, dark, system
    
    var optionName: String {
        return "Тема"
    }
    
    func associatedIcon() -> String {
        switch self {
        case .light:
            return "🌕"
        case .dark:
            return "🌑"
        case .system:
            return "🌗"
        }
    }
}

public enum Sound: String, SettingsOption {
    case on,off
    
    var optionName: String {
        return "Звуки"
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

// MARK: - Settings Manager
final class UserSettings {
    enum CodingKeys {
        static let username = "BunkerUsername"
        static let sound = "SoundIsOn"
        static let appearence = "Appearence"
        static let language = "Language"
    }
    
    static let shared = UserSettings()
    private let storage = UserDefaults.standard
    
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
                
    public var appearance: Appearence = .system {
        didSet {
            storage.set(appearance.rawValue, forKey: CodingKeys.appearence)
        }
    }
    
    public var isPremium: Bool = false {
        didSet {
            
        }
    }
    
    init() {
        self.username = storage.object(forKey: CodingKeys.username) as? String
        if let sound = storage.object(forKey: CodingKeys.sound) as? String {
            self.volume = Sound(rawValue: sound) ?? .off
        }
        if let theme = storage.object(forKey: CodingKeys.appearence) as? String {
            self.appearance = Appearence(rawValue: theme) ?? .system
        }
        if let langauge = storage.object(forKey: CodingKeys.language) as? String {
            self.language = Language(rawValue: langauge) ?? .ru
        }
    }
}
