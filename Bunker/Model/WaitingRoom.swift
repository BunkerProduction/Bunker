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

extension WaitingRoom: Hashable { }

struct User {
    let orderNumber: Int
    let username: String
    let isCreator: Bool
}

extension User: Hashable { }
