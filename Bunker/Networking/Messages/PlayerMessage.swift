//
//  PlayerMessage.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 30.09.2022.
//

import Foundation

struct PlayerMessage {
    let id: String
    let username: String
    let attributes: [AttributeMessage]
}


extension PlayerMessage: Codable { }
