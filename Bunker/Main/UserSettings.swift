//
//  SettingsController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import Foundation

public enum Language: String {
    case ru,eng,zhi
}

public enum Appearence: String {
    case light, dark, system
}

final class UserSettings {
    enum CodingKeys {
        static let username = "BunkerUsername"
        static let sound = "SoundIsOn"
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
            
        }
    }
    
    public var isVolumeOn: Bool = true {
        didSet {
            storage.set(isVolumeOn, forKey: CodingKeys.sound)
        }
    }
                
    public var appearance: Appearence = .system {
        didSet {
            
        }
    }
    
    init() {
        self.username = storage.object(forKey: CodingKeys.username) as? String
        self.isVolumeOn = storage.bool(forKey: CodingKeys.sound)
    }
}
