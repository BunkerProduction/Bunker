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
    let players: [PlayerMessage]
    let gameState: GameState
    let initialNumberOfPlayers: Int
    let turn: String
    let round: Int
}

extension GameMessage: Codable { }


struct PlayerMessage {
    let id: String
    let username: String
    let attributes: [AttributeMessage]
}

struct AttributeMessage {
    let id: Int
    let isExposed: Bool
}

struct AttributeChoiceMessage {
    let attributeID: Int
    let playerID: String

    var json: Data {
        let dict: [String: Any] = [
            "number_attribute": attributeID,
            "playerID": playerID
        ]
        guard JSONSerialization.isValidJSONObject(dict) else { fatalError("Invalid JSON") }
        guard let jsonObject = try? JSONSerialization.data(withJSONObject: dict) else {
            fatalError("Couldn't Decode")
        }
        return jsonObject
    }
}

//    {
//    "number_attribute": 1,
//    "playerID": "2f6936a2295be8b5",
//    "sessionID": "698484"
//    }

extension PlayerMessage: Codable { }
extension AttributeMessage: Codable { }
