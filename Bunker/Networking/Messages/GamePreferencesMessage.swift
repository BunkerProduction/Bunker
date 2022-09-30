//
//  GamePreferencesMessage.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 30.09.2022.
//

import Foundation

// MARK: - GamePrefs Message
struct GamePreferencesMessage {
    let votingTime: Int
    let catastropheId: Int
    let gameConditions: [ShelterConditionsMessage]
    let shelterId: Int
    let difficultyId: Int
}

extension GamePreferencesMessage: Codable { }
