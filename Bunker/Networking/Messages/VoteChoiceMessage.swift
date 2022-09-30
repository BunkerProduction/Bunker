//
//  VoteChoiceMessage.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 30.09.2022.
//

import Foundation

struct VoteChoiceMessage: Codable {
    let player: String
    let votedFor: String

    var jsonString: String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        let string = String(data: data, encoding: .utf8)

        return string!
    }
}
