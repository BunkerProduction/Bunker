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
    let turn: String
    let round: Int
}

extension GameMessage: Codable { }

// gameMessage not decoding check fields
/*
[{"type":"game_model","sessionID":"279942","preferences":{"votingTime":2,"catastropheId":0,"shelterId":1,"difficultyId":1},"players":[{"id":"cef9f6e89c476ae9","isCreator":true,"username":"Man","attributes":[126,62,96,63,44,21]}],"gameState":"normal","initialNumberOfPlayers":1,"turn":"cef9f6e89c476ae9","round":0}]
*/
