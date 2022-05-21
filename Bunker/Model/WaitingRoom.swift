//
//  WaitingRoom.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 20.05.2022.
//

import Foundation

struct WaitingRoom {
    var users: [User] = []
    var roomCode: String = ""
}

struct User: Hashable {
    let username: String
    let isCreator: Bool
}
