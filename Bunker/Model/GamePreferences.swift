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
        difficulty = nil
    }
    
    func winRatio(numberOfPlayers: Int) -> Int {
        /*
         cколько человек должно выиграть в зависимости от выбранной сложности
          Легко - 60%
         Средне - 50
         и тд
         */
        return 0
    }
}


// MARK: - Difficulty
struct GameDifficulty {
    
}
