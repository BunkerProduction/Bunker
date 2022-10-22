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
    case kickedPlayer
    case error
    
    enum CodingKeys: String, CodingKey {
        case handshake = "handahske"
        case waiting_room = "waiting_room"
        case game_model = "game_model"
        case kickedPlayer = "kickedPlayer"
        case error = "error"
    }
}

struct MessageSinData: Codable {
    let type: MessageType
}

struct Handshake: Codable {
    let id: String
}

struct ErrorMessage: Codable {
    let message: String
}
