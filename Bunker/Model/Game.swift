//
//  Game.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.05.2022.
//

import Foundation

enum GameState: String, Codable {
    case normal, voting
}

struct Game {
    let gamePreferences: GamePreferences
    let players: [User]
    let turn: Int
    let round: Int
    let gameState: GameState
}
