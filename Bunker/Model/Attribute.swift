//
//  Attribute.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 01.10.2022.
//

import Foundation

struct Attribute {
    let id: Int
    var icon: String = "👩🏻‍🎓"
    let type: Category
    var isExposed: Bool = false
    let description: String

    enum Category: String, Codable {
        case profession = "Profession",
             health = "Health",
             biology = "Biology",
             hobby = "Hobby",
             luggage = "Luggage",
             fact = "Fact"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case type = "category"
        case description
    }

    init(identifier: Int, position: Int, isExposed: Bool) {
        let attribute = Self.allAttributes[position].first(where: { $0.id == identifier})!
        self.icon = Attribute.fileNames[position]!.1
        self.id = attribute.id
        self.type = attribute.type
        self.description = attribute.description
        self.isExposed = isExposed
    }

    static var allAttributes: [[Attribute]] = []

    static let fileNames = [
        0: ("profession", "🧑🏼‍🎓"),
        1: ("health", "🫀"),
        2: ("biology", "👽"),
        3: ("hobby", "🏓"),
        4: ("luggage", "🎒"),
        5: ("fact", "⚠️")
    ]

    static func load() {
        for val in fileNames.sorted(by: { $0.0 < $1.0 }) {
            let decoder = JSONDecoder()
            let data = JsonManager.shared.readLocalFile(forName: val.value.0)!

            let categoryAttributes = try! decoder.decode([Attribute].self, from: data)
            allAttributes.append(categoryAttributes)
        }
    }
}

extension Attribute: Hashable, Codable { }
