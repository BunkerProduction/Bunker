//
//  WebSocketTypes.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import Foundation

let baseURL = "https://ktor-bunker.herokuapp.com/game"
let baseWSS = "ws://ktor-bunker.herokuapp.com/game"


struct GamePreferencesMessage {
    let votingTime: Int
    let catastropheId: Int
    let shelterId: Int
    let difficultyId: Int
}

extension GamePreferencesMessage: Codable { }
