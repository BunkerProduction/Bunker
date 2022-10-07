//
//  KickMessage.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 07.10.2022.
//

import Foundation

struct PlayerKicked {
    let id: String
}

extension PlayerKicked: Codable { }
