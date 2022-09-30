//
//  WaitingRoomMessage.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 30.09.2022.
//

import Foundation

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
