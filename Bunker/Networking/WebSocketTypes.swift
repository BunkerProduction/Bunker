//
//  WebSocketTypes.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import Foundation

// MARK: - GamePrefs Message
struct GamePreferencesMessage {
    let votingTime: Int
    let catastropheId: Int
    let shelterId: Int
    let difficultyId: Int
}

extension GamePreferencesMessage: Codable { }

// MARK: - WaitingRoom Message
struct WaitingRoomMessage {
    var players: [UserMessage] = []
    var roomCode: String = ""
}

extension WaitingRoomMessage: Codable {
    enum CodingKeys: String, CodingKey {
        case roomCode = "sessionID"
        case players = "players"
    }
}

// MARK: - UserMessage
struct UserMessage {
    let username: String
    let isCreator: Bool
}

extension UserMessage: Codable { }


// MARK: - GameMessage
struct GameMessage {
    let sessionID: String
    let preferences: GamePreferencesMessage
    let players: [UserMessage]
    let gameState: GameState
    let initialNumberOfPlayers: Int
    let turn: Int
    let round: Int
}

extension GameMessage: Codable { }
