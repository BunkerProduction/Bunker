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
    let players: [Player]
    let turn: Int
    let round: Int
    let gameState: GameState
    let myPlayer: Player
}

struct Player {
    let UID: String
    let username: String
    let attributes: [Attribute]
}

extension Player: Hashable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.UID == rhs.UID
    }
}

struct Attribute {
    let icon: String
    let type: String
    let description: String

    init(identifier: Int) {
        icon = "🥶"
        type = "Biology"
        description = "some description"
    }
}

extension Attribute: Hashable { }
