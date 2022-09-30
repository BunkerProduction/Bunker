//
//  Player.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 01.10.2022.
//

import Foundation

struct Player {
    let UID: String
    let username: String
    let attributes: [Attribute]
    let votesForHim: Double
}

extension Player: Hashable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.UID == rhs.UID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(UID)
    }
}
