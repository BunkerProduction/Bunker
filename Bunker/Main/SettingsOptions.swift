//
//  SettingsOptions.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.05.2022.
//

import Foundation

protocol SettingsOption {
    func associatedIcon() -> String
    var allCases: [Self] { get }
    var optionType: String { get }
    var optionName: String { get }
}

public enum Language: String, SettingsOption, CaseIterable {
    case ru = "Русский"
    case eng = "Английский"
    case zhi = "Китайский"
    
    var optionType: String {
        return "Язык"
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

public enum Appearence: String, SettingsOption, CaseIterable {
    case light = "Cветлая", dark = "Темная", system = "Система"
    
    var optionType: String {
        return "Тема"
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
        }
    }
}

public enum Sound: String, SettingsOption, CaseIterable {
    case on = "Вкл", off = "Выкл"
    
    var optionType: String {
        return "Звуки"
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
