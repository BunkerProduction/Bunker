//
//  GameMessage.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 30.09.2022.
//

import Foundation

// MARK: - GameMessage
struct GameMessage {
    let sessionID: String
    let preferences: GamePreferencesMessage
    let players: [PlayerMessage]
    let gameState: GameState
    let initialNumberOfPlayers: Int
    let turn: String
    let round: Int
    let votes: [String: Int]?
}

extension GameMessage: Codable { }
