//
//  AttributeMessage.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 30.09.2022.
//

import Foundation

struct AttributeMessage {
    let id: Int
    let isExposed: Bool
}

struct AttributeChoiceMessage: Codable {
    let attributePos: Int
    let playerID: String

    enum CodingKeys: String, CodingKey {
        case attributePos = "attributeNumber"
        case playerID
    }

    var jsonString: String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        let string = String(data: data, encoding: .utf8)

        return string!
    }
}

extension AttributeMessage: Codable { }
