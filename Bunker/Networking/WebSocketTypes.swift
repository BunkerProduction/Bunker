//
//  WebSocketTypes.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import Foundation

enum MessageType: String, Codable {
    case handshake
    case waiting_room
    case game_model
    
    enum CodingKeys: String, CodingKey {
        case handshake = "handahske"
        case waiting_room = "waiting_room"
        case game_model = "game_model"
    }
}

struct MessageSinData: Codable {
    let type: MessageType
}

struct Handshake: Codable {
    let id: String
}

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
    let id: String
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
