//
//  UserMessage.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 30.09.2022.
//

import Foundation

// MARK: - UserMessage
struct UserMessage {
    let id: String
    let username: String
    let isCreator: Bool
}

extension UserMessage: Codable { }
