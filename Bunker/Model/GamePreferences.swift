//
//  GamePreferences.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 14.05.2022.
//

import Foundation

struct GamePreferences {
    var votingTime: Int = 0
    var catastrophe: Catastrophe?
    var shelter: Shelter?
    var conditions: [ShelterCondition] = []
    var difficulty: GameDifficulty?

    init() {
        catastrophe = Catastrophe.getAll()[0]
        shelter = Shelter.random()
        difficulty = GameDifficulty(rate: 1)
    }

    init(message: GamePreferencesMessage) {
        votingTime = message.votingTime
        catastrophe = Catastrophe.getAll()[message.catastropheId]
        shelter = Shelter(id: message.shelterId)
        conditions = message.gameConditions.map {
            ShelterCondition(id: $0.Condition, isExposed: $0.isExposed)
        }
        difficulty = GameDifficulty(rate: message.difficultyId)
    }

    init(catastropheId: Int, conditions: [ShelterCondition]?) {
        catastrophe = Catastrophe.getAll()[catastropheId]
        shelter = Shelter.random()
        difficulty = GameDifficulty(rate: 1)
        self.conditions = conditions ?? []
    }
}

extension GamePreferences: Codable { }


// MARK: - Difficulty
struct GameDifficulty {
    let rate: Int
}

extension GameDifficulty: Codable { }
