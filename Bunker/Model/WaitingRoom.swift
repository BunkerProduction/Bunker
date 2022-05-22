//
//  WaitingRoom.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 20.05.2022.
//

import Foundation

struct WaitingRoom {
    var players: [User] = []
    var roomCode: String = ""
}

extension WaitingRoom: Codable {
    enum CodingKeys: String, CodingKey {
        case roomCode = "sessionID"
        case players = "players"
    }
}

struct User {
    let username: String
    let isCreator: Bool
}

extension User: Codable { }

extension User: Hashable { }
