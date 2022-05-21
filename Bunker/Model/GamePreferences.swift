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
    var difficulty: GameDifficulty?
    
    init() {
        catastrophe = Catastrophe.getAll()[0]
        shelter = nil
        difficulty = GameDifficulty(rate: 1)
    }
}

extension GamePreferences: Codable { }


// MARK: - Difficulty
struct GameDifficulty {
    let rate: Int
}

extension GameDifficulty: Codable { }
