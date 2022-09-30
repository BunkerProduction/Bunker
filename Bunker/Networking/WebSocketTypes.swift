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
